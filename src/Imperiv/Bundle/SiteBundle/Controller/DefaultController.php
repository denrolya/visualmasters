<?php

namespace Imperiv\Bundle\SiteBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Imperiv\Bundle\SiteBundle\Form\Type\DesignOrderType;
use Imperiv\Bundle\SiteBundle\Form\Type\VideoOrderType;

class DefaultController extends Controller
    {
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
            $this->createForm(new DesignOrderType())->createView(),
            $this->createForm(new VideoOrderType())->createView()
        ];

        return ['categories' => $categories, 'forms' => $forms];
    }
}
