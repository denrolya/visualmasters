<?php

namespace SiteBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use SiteBundle\Entity\File;
use SiteBundle\Entity\GalleryPage;
use SiteBundle\Entity\Order;
use SiteBundle\Entity\Video;
use SiteBundle\Form\OrderType;
use SiteBundle\Services\ReCaptchaService;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Finder\Finder;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="index")
     * @Template()
     */
    public function indexAction()
    {
        $em = $this->getDoctrine()->getManager();

        $form = $this
            ->createForm(OrderType::class, new Order(), [
                'action' => $this->generateUrl('process_order')
            ])
            ->createView();

        $galleries = $em->getRepository(GalleryPage::class)->findAll();

        $randomSlides = [];

        /** @var GalleryPage $gallery */
        foreach ($galleries as $index => $gallery) {
            $gallerySlides = $gallery->getSlides();
            if (count($gallerySlides) > 0) {
                array_push($randomSlides, $gallerySlides[array_rand($gallerySlides->getKeys())]);
            }
        }

        $video = $em->getRepository(Video::class)->findAll()[0];

        return [
            'form' => $form,
            'slides' => $randomSlides,
            'videoObject' => $video
        ];
    }

    /**
     * @Route("/galleries/{slug}", name="gallery_page")
     * @Template()
     */
    public function galleryAction(GalleryPage $galleryPage)
    {
        $form = $this
            ->createForm(OrderType::class, new Order(), [
                'action' => $this->generateUrl('process_order')
            ])
            ->createView();

        return [
            'gallery' => $galleryPage,
            'form' => $form
        ];
    }

    /**
     * @Route("/order/{id}/invoice.html", name="order_invoice_html")
     * @Method({"GET"})
     * @Template("::invoice.html.twig")
     */
    public function invoiceHTMLAction(Order $order)
    {
        return [
            'order' => $order
        ];
    }

    /**
     * @Route("/order/{id}/invoice.pdf", name="order_invoice_pdf")
     * @Method({"GET"})
     */
    public function invoicePDFAction(Order $order)
    {
        $pageUrl = $this->generateUrl('order_invoice_html', [
            'id' => $order->getId()
        ], UrlGeneratorInterface::ABSOLUTE_URL);

        $now = new \DateTime();
        $invoiceFilename = "invoice_" . $now->format('Y-m-d_H-i') . '.pdf';
        $invoicesDir = $this->container->getParameter('files_dir') . '/' . $order->getId() . '/invoices/';

        $pdf = $this->get('knp_snappy.pdf')->getOutput($pageUrl);

        $pdfFile = fopen($invoicesDir . $invoiceFilename, 'w+');
        fwrite($pdfFile, $pdf);
        fclose($pdfFile);

        return new Response($pdf,
            Response::HTTP_OK, [
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => 'attachment; filename="' . $invoiceFilename . '"'
            ]
        );
    }

    /**
     * @Route("/order/{id}/order.zip", name="order_zip")
     * @Method({"GET"})
     */
    public function downloadOrderFilesAsZipAction(Order $order)
    {
        $zip = new \ZipArchive();
        $zipName = 'order-' . time() . ".zip";
        $zip->open($zipName, \ZipArchive::CREATE);

        $finder = new Finder();
        $finder
            ->files()
            ->in($this->container->getParameter('files_dir') . '/' . $order->getId() . '/invoices');

        foreach ($finder as $file) {
            /** @var \Symfony\Component\Finder\SplFileInfo $file */
            if (strtolower($file->getExtension()) !== 'pdf') continue;
            $zip->addFromString($file->getFilename(), $file->getContents());
        }

        $zip->close();

        $response = new BinaryFileResponse("../web/" . $zipName);
        $response->setContentDisposition(ResponseHeaderBag::DISPOSITION_ATTACHMENT);

        return $response;
    }

    /**
     * @Route("/order", name="process_order")
     * @Method({"POST"})
     */
    public function processOrderAction(Request $request)
    {
        $order = new Order();
        $form = $this->createForm(OrderType::class, $order);
        $form->handleRequest($request);

        $rc2Response = $request->request->get('g-recaptcha-response');
        $rc2Verification = $this->get(ReCaptchaService::class)->verify($rc2Response);

        if ($form->isValid() && $rc2Verification) {
            $em = $this->get('doctrine.orm.entity_manager');

            $em->persist($order);

            $em->flush();

            if ($file = $request->files->get('file')) {

                $filename = $order->getId() . '-' . md5(uniqid()) . '.' . $file->guessExtension();
                $orderDirAbsolutePath = $this->container->getParameter('files_dir') . '/' . $order->getId();
                $file->move($orderDirAbsolutePath, $filename);

                $newFile = (new File())
                    ->setName($filename)
                    ->setRelativePath('/uploads/orders/' . $order->getId() . '/' . $filename)
                    ->setAbsolutePath($orderDirAbsolutePath . '/' . $filename)
                    ->setSize($file->getClientSize());

                $order->setFile($newFile);

                $em->persist($newFile);

                $em->flush();
            }

            $this->addFlash('success', 'You have successfully placed an order on VisualMasters!');

            $mailer = $this->get('app.mailgun_service');

            $mailer->sendMail(
                    $order->getEmail(),
                    '[NEW] Order was successfully submitted!',
                    'Your order to VisualMasters was successfully created.'
                );

            $mailer->sendMail(
                    'info@visualmasters.co.uk',
                    '[NEW] Order was successfully created!',
                    $this->renderView(
                        '::order_success.email.html.twig',
                        ['order' => $order]
                    )
                );

            return new JsonResponse(['status' => 'ok'], Response::HTTP_OK);
        }
    }
}
