<?php

namespace SiteBundle\Controller;

use SiteBundle\Entity\GalleryPage;
use SiteBundle\Entity\Video;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

class DefaultController extends Controller
{
    /**
     * @Template()
     */
    public function navigationAction()
    {
        $galleries = $this
            ->getDoctrine()
            ->getRepository(GalleryPage::class)
            ->createQueryBuilder('g')
            ->where("g.pageName <> 'home'")
            ->getQuery()
            ->getResult();

        return compact('galleries');
    }

    /**
     * @Route("/media", name="media_page")
     * @Template()
     */
    public function mediaAction()
    {
        $videos = $this->getDoctrine()->getRepository(Video::class)->findAll();

        return compact('videos');
    }
}
