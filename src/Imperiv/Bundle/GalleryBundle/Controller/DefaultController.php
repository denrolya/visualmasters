<?php

namespace Imperiv\Bundle\GalleryBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route,
    Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

use Imperiv\Bundle\GalleryBundle\Entity\GalleryPage,
    Imperiv\Bundle\GalleryBundle\Entity\Slide;

class DefaultController extends Controller
{
    const HOMEPAGE_NAME = "home";
    
    /**
     * @Route("/", name="index_page")
     */
    public function indexAction()
    {
        $response = $this->forward('ImperivGalleryBundle:Default:gallery', [
            'name'  => self::HOMEPAGE_NAME,
        ]);

        return $response;
    }
    /**
     * @Route("/gallery/{name}", name="gallery_page")
     * @Template()
     */
    public function galleryAction($name)
    {
    	$em = $this->getDoctrine()->getManager();
        
        $galleryPage = $em->getRepository('ImperivGalleryBundle:GalleryPage')->findOneByPageName($name);
                
        if (!$galleryPage) {
            throw $this->createNotFoundException("Page doesn't exist!");
        }

        return ['gallery' => $galleryPage];
    }
}