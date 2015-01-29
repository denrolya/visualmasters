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
    /**
     * @Route("/", name="index_page", defaults={"gallery_name":"home"})
     * @Route("/{gallery_name}", name="gallery_page", requirements={"gallery_name":"home|design|art|models"})
     * @Template()
     */
    public function galleryAction($gallery_name)
    {
    	$em = $this->getDoctrine()->getManager();
        
        $galleryPage = $em->getRepository('ImperivGalleryBundle:GalleryPage')->findOneByPageName($gallery_name);
                
        if (!$galleryPage) {
            throw $this->createNotFoundException("Page doesn't exist!");
        }

        return ['gallery' => $galleryPage];
    }
}