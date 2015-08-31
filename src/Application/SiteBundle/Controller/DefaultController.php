<?php

namespace Application\SiteBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\HttpFoundation\Request;
use Application\SiteBundle\Form\Type\DesignOrderType,
    Application\SiteBundle\Form\Type\VideoOrderType,
    Application\SiteBundle\Form\Type\InteriorOrderType;

class DefaultController extends Controller
{

    /**
     * @Template()
     */
    public function navigationAction()
    {
        $galleries = $this->getDoctrine()->getRepository('ImperivGalleryBundle:GalleryPage')->createQueryBuilder('g')
            ->where("g.pageName <> 'home'")
            ->getQuery()
            ->getResult();

        return compact('galleries');
    }

    /**
     * @Route("/video", name="video_page")
     * @Template()
     */
    public function videoAction()
    {
        $videos = $this->getDoctrine()->getRepository("ImperivSiteBundle:Video")->findAll();

        return compact('videos');
    }

    /**
     * @Route("/explore", name="explore_more_page")
     * @Template()
     */
    public function exploreAction()
    {
        $categories = $this->getDoctrine()->getRepository("ImperivSiteBundle:Category")->findAll();

        $forms = [
            $this->createForm(new VideoOrderType())->createView(),
            $this->createForm(new DesignOrderType())->createView(),
            $this->createForm(new InteriorOrderType(), null, ['action' => $this->generateUrl('place_order_interior')])->createView()
        ];

        return ['categories' => $categories, 'form' => $form];
    }
}
