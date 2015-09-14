<?php

namespace Application\GalleryBundle\Controller;

use Application\SiteBundle\Entity\Document;
use Application\SiteBundle\Entity\InteriorOrder;
use Application\SiteBundle\Entity\SpecialOrder;
use Application\SiteBundle\Entity\WebOrder;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route,
    Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

use Symfony\Component\HttpFoundation\Request;

use Application\SiteBundle\Form\Type\InteriorOrderType,
    Application\SiteBundle\Form\Type\WebOrderType,
    Application\SiteBundle\Form\Type\SpecialOrderType;

class GalleryController extends Controller
{
    const HOMEPAGE_NAME = "home";
    
    /**
    /**
     * @Route("/", name="index_page", defaults={"gallery_name":"home"})
     * @Route("/{gallery_name}", name="gallery_page", requirements={"gallery_name":"home|interior|web|special|design"})
     * @Template()
     */
    public function galleryAction($gallery_name)
    {
        
        $galleryPage = $this->getDoctrine()->getRepository('ImperivGalleryBundle:GalleryPage')->findOneByPageName($gallery_name);
                
        if (!$galleryPage) {
            throw $this->createNotFoundException("Page doesn't exist!");
        }
            switch ($gallery_name) {
                case 'interior':
                    $form = $this->createForm(new InteriorOrderType(), null, ['action' => $this->generateUrl('place_order_interior')])->createView();
                    break;
                case 'special':
                    $form = $this->createForm(new SpecialOrderType(), null, ['action' => $this->generateUrl('place_order_special')])->createView();
                    break;
                case 'web':
                    $form = $this->createForm(new WebOrderType(), null, ['action' => $this->generateUrl('place_order_web')])->createView();
                    break;
            }

        return ($gallery_name != 'home') ? ['gallery' => $galleryPage, 'form' => $form] : ['gallery' => $galleryPage];
    }

    /**
     * @Route("/order/interior", name="place_order_interior")
     */
    public function interiorOrderAction(Request $request)
    {
        $entity = new InteriorOrder();
        $form = $this->createForm(new InteriorOrderType(), $entity);
        $form->handleRequest($request);


        if ($form->isValid())
        {
            $em = $this->getDoctrine()->getManager();

            $em->persist($entity);

            $em->flush();

            foreach(['StyleExample', 'Drawing', 'EnvironmentPhoto'] as $index => $method) {
                $file = $entity->{"get$method"}();

                if ($file) {

                    // Generate a unique name for the file before saving it
                    $fileName = md5(uniqid()) . '.' . $file->guessExtension();

                    // Move the file to the directory where brochures are stored
                    $uploadDir = $this->container->getParameter('uploads_dir') . "/" . $entity->getId() . "/";

                    $file->move($uploadDir, $fileName);

                    // Update the 'brochure' property to store the PDF file name
                    // instead of its contents
                    $entity->{"set$method"}($fileName);
                }

                $em->flush();
            }
        }

        $this->addFlash('success', 'You have successfully placed an order on IMPERIUMDESIGN!');

        return $this->redirectToRoute('gallery_page', ['gallery_name' => 'art']);
    }

    /**
     * @Route("/order/web", name="place_order_web")
     */
    public function webOrderAction(Request $request)
    {
        $entity = new WebOrder();
        $form = $this->createForm(new WebOrder(), $entity);
        $form->handleRequest($request);


        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();

            $em->persist($entity);

            $em->flush();
        }

        $this->addFlash('success', 'You have successfully placed an order on IMPERIUMDESIGN!');

        return $this->redirectToRoute('gallery_page', ['gallery_name' => 'web']);
    }

    /**
     * @Route("/order/special", name="place_order_special")
     */
    public function specialOrderAction(Request $request)
    {
        $entity = new SpecialOrder();
        $form = $this->createForm(new SpecialOrderType(), $entity);
        $form->handleRequest($request);


        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();

            $em->persist($entity);

            $em->flush();
        }

        $this->addFlash('success', 'You have successfully placed an order on IMPERIUMDESIGN!');

        return $this->redirectToRoute('gallery_page', ['gallery_name' => 'special']);
    }
}