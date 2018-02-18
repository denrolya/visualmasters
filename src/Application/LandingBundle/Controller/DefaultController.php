<?php

namespace Application\LandingBundle\Controller;

use Application\GalleryBundle\Entity\GalleryPage;
use Application\LandingBundle\Entity\Order;
use Application\LandingBundle\Entity\File;
use Application\LandingBundle\Form\OrderType;
use Application\SiteBundle\Entity\Video;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\Finder\Finder;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="index")
     * @Template()
     */
    public function indexAction()
    {
        $em = $this->getDoctrine()->getManager();

        $form = $this->createForm(new OrderType(), new Order(), ['action' => $this->generateUrl('process_order')])->createView();

        $galleries = $em->getRepository(GalleryPage::class)->findAll();

        $randomSlides = [];

        /** @var GalleryPage $gallery */
        foreach($galleries as $index => $gallery) {
            $gallerySlides = $gallery->getSlides();
            if  (count($gallerySlides) > 0)
                array_push($randomSlides, $gallerySlides[array_rand($gallerySlides->getKeys())]);
        }

        $video = $em->getRepository(Video::class)->findAll()[0];

        return ['form' => $form, 'slides' => $randomSlides, 'videoObject' => $video];
    }

    /**
     * @Route("/galleries/{slug}", name="gallery_page")
     * @Template()
     */
    public function galleryAction($slug)
    {

        $galleryPage = $this->getDoctrine()->getRepository('ImperivGalleryBundle:GalleryPage')->findOneBySlug($slug);

        if (!$galleryPage) {
            throw $this->createNotFoundException("Page doesn't exist!");
        }

        $form = $this->createForm(new OrderType(), new Order(), ['action' => $this->generateUrl('process_order')])->createView();

        return ['gallery' => $galleryPage, 'form' => $form];
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
    public function invoicePDFAction($id)
    {
        $pageUrl = $this->generateUrl('order_invoice_html', [
            'id' => $id
        ], true); // use absolute path!

        $now = new \DateTime();
        $invoiceFilename = "invoice_" . $now->format('Y-m-d_H-i') . '.pdf';
        $invoicesDir = $this->container->getParameter('files_dir') . '/' . $id . '/invoices/';

        $pdfFile = $this->get('knp_snappy.pdf')->generate($pageUrl,$invoicesDir . $invoiceFilename);

        return new Response($pdfFile, Response::HTTP_OK, [
            'Content-Type'          => 'application/pdf',
            'Content-Disposition'   => 'attachment; filename="' . $invoiceFilename . '"'
        ]);
    }

    /**
     * @Route("/order/{id}/order.zip", name="order_zip")
     * @Method({"GET"})
     */
    public function downloadOrderFilesAsZipAction(Order $order)
    {
        $em = $this->get('doctrine.orm.entity_manager');

        $zip = new \ZipArchive();
        $zipName = 'order-'.time().".zip";
        $zip->open($zipName,  \ZipArchive::CREATE);

        $finder = new Finder();
        $finder->files()->in($this->container->getParameter('files_dir') . '/' . $order->getId(). '/invoices');

        foreach ($finder as $file) {
            /** @var \Symfony\Component\Finder\SplFileInfo $file */
            if (strtolower($file->getExtension()) !== 'pdf') continue;
            $zip->addFromString($file->getFilename(), $file->getContents());
        }

        $zip->close();

        $response = new BinaryFileResponse("../web/".$zipName);
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
        $form = $this->createForm(new OrderType(), $order);
        $form->handleRequest($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();

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

            $message = \Swift_Message::newInstance()
                ->setSubject('[NEW] Order was successfully submitted!')
                ->setFrom('no-reply@visualmasters.co.uk')
                ->setTo($order->getEmail())
                ->setBody($order->getComments(), 'text/html');

            if (isset($newFile)) {
                $message->attach(\Swift_Attachment::fromPath($newFile->getAbsolutePath())->setFilename($newFile->getName()));
            }

            $failedRecipients = [];

            $this->get('mailer')->send($message, $failedRecipients);

            return new JsonResponse(['status' => 'ok'], Response::HTTP_OK);
        }
    }
}
