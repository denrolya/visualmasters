<?php

namespace Imperiv\Bundle\GalleryBundle\Controller;

use Imperiv\Bundle\SiteBundle\Entity\InteriorOrder;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route,
    Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

use Symfony\Component\HttpFoundation\Request;

use Imperiv\Bundle\SiteBundle\Form\Type\InteriorOrderType,
    Imperiv\Bundle\SiteBundle\Form\Type\DesignOrderType,
    Imperiv\Bundle\SiteBundle\Form\Type\VideoOrderType;

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
            $form = $this->createForm(new InteriorOrderType(), null, ['action' => $this->generateUrl('place_order_interior')])->createView();
//            switch ($gallery_name) {
//                case 'art':
//                    $form = $this->createForm(new InteriorOrderType(), null, ['action' => $this->generateUrl('place_order_interior')])->createView();
//                    break;
//                case 1:
//                    echo "i equals 1";
//                    break;
//                case 2:
//                    echo "i equals 2";
//                    break;
//            }

        return ($gallery_name != 'home') ? ['gallery' => $galleryPage, 'form' => $form] : ['gallery' => $galleryPage];
    }

    /**
     * @Route("/order/interior", name="place_order_interior")
     */
    public function interiorOrderAction(Request $request)
    {
        $entity = new InteriorOrder();
        $form = $this->createForm(new InteriorOrderType(), $entity);

        $form->bind($request);

        if ($form->isValid())
        {
            var_dump($form->getData()); die;
        }
    }
}