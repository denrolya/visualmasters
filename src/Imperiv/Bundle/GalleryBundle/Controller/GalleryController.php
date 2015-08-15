<?php

namespace Imperiv\Bundle\GalleryBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route,
    Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

class GalleryController extends Controller
{
    const HOMEPAGE_NAME = "home";
    
    /**
    /**
     * @Route("/", name="index_page", defaults={"gallery_name":"home"})
     * @Route("/{gallery_name}", name="gallery_page", requirements={"gallery_name":"home|design|art|models"})
     * @Template()
     */
    public function galleryAction($gallery_name)
    {
        
        $galleryPage = $this->getDoctrine()->getRepository('ImperivGalleryBundle:GalleryPage')->findOneByPageName($gallery_name);
                
        if (!$galleryPage) {
            throw $this->createNotFoundException("Page doesn't exist!");
        }
        
        $slides = $this->getDoctrine()->getRepository('ImperivGalleryBundle:Slide')->findSlidesInGalleryApplyingDisplayOrder($galleryPage);

        return ['gallery' => $galleryPage, 'slides' => $slides];
    }
}