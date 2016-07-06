<?php

namespace Application\LandingBundle\Controller;

use Application\GalleryBundle\Entity\GalleryPage;
use Application\LandingBundle\Entity\BaseOrder;
use Application\LandingBundle\Form\BaseOrderType;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="index")
     * @Template()
     */
    public function indexAction()
    {
        $form = $this->createForm(new BaseOrderType(), new BaseOrder(), ['action' => $this->generateUrl('process_order')])->createView();

        $galleries = $this->getDoctrine()->getRepository(GalleryPage::class)->findAll();

        $randomSlides = [];

        /** @var GalleryPage $gallery */
        foreach($galleries as $index => $gallery) {
            $gallerySlides = $gallery->getSlides();
            array_push($randomSlides, $gallerySlides[array_rand($gallerySlides->getKeys())]);
        }

        return ['form' => $form, 'slides' => $randomSlides];
    }

    /**
     * @Route("/galleries/{gallery_name}", name="gallery_page")
     * @Template()
     */
    public function galleryAction($gallery_name)
    {

        $galleryPage = $this->getDoctrine()->getRepository('ImperivGalleryBundle:GalleryPage')->findOneByPageName($gallery_name);

        if (!$galleryPage) {
            throw $this->createNotFoundException("Page doesn't exist!");
        }

        $form = $this->createForm(new BaseOrderType(), new BaseOrder(), ['action' => $this->generateUrl('process_order')])->createView();

        return ['gallery' => $galleryPage, 'form' => $form];
    }

    /**
     * @Route("/order", name="process_order")
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

            $this->addFlash('success', 'You have successfully placed an order on VisualMasters!');

            $message = \Swift_Message::newInstance()
                ->setSubject('[New] Order was successfully submitted!')
                ->setFrom('no-reply@visualmasters.co.uk')
                ->setTo($order->getEmail())
                ->setBody($order->getComments(), 'text/html');

            $failedRecipients = [];

            $this->get('mailer')->send($message, $failedRecipients);

            return $this->redirectToRoute('index');
        }
    }
}
