<?php

namespace Application\LandingBundle\Controller;

use Application\GalleryBundle\Entity\GalleryPage;
use Application\LandingBundle\Entity\BaseOrder;
use Application\LandingBundle\Entity\File;
use Application\LandingBundle\Form\BaseOrderType;
use Application\SiteBundle\Entity\Video;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="index")
     * @Template()
     */
    public function indexAction()
    {
        $em = $this->getDoctrine()->getManager();

        $form = $this->createForm(new BaseOrderType(), new BaseOrder(), ['action' => $this->generateUrl('process_order')])->createView();

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

        $form = $this->createForm(new BaseOrderType(), new BaseOrder(), ['action' => $this->generateUrl('process_order')])->createView();

        return ['gallery' => $galleryPage, 'form' => $form];
    }

    /**
     * @Route("/order", name="process_order")
     * @Method({"POST"})
     */
    public function processOrderAction(Request $request)
    {
        $order = new BaseOrder();
        $form = $this->createForm(new BaseOrderType(), $order);
        $form->handleRequest($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();

            $em->persist($order);

            $em->flush();

            if ($file = $request->files->get('zipfile')) {

                $filename = $order->getId() . '-' . md5(uniqid()) . '.' . $file->guessExtension();
                $file->move($this->container->getParameter('files_dir'), $filename);

                $newFile = (new File())
                    ->setName($filename)
                    ->setRelativePath('/uploads/orders/' . $filename)
                    ->setAbsolutePath($this->container->getParameter('files_dir') . '/' . $filename)
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
            $message->attach(\Swift_Attachment::fromPath($newFile->getAbsolutePath()));

            $failedRecipients = [];

            $this->get('mailer')->send($message, $failedRecipients);

            return new JsonResponse(['status' => 'ok'], 200);
        }
    }
}
