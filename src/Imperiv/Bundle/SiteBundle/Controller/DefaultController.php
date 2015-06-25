<?php

namespace Imperiv\Bundle\SiteBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

class DefaultController extends Controller
{
    /**
     * @Route("/hell/{name}")
     * @Template()
     */
    public function indexAction($name)
    {
        return array('name' => $name);
    }

    /**
     * @Route("/video", name="video_page")
     * @Template()
     */
    public function videoAction()
    {
        $videos = $this->getDoctrine()->getRepository("ImperivSiteBundle:Video")->findAll();

        return ['videos' => $videos];
    }
}
