<?php

namespace Application\SiteBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\HttpFoundation\Request;
use Application\SiteBundle\Form\Type\DesignOrderType,
    Application\SiteBundle\Form\Type\VideoOrderType,
    Application\SiteBundle\Form\Type\InteriorOrderType,
    Application\SiteBundle\Form\Type\BaseType;
use Application\SiteBundle\Entity\BaseOrder;

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
     * @Route("/media", name="media_page")
     * @Template()
     */
    public function mediaAction()
    {
        $videos = $this->getDoctrine()->getRepository("ImperivSiteBundle:Video")->findAll();

        return compact('videos');
    }

    /**
     * @Route("/explore", name="explore_more_page")
     * @Template()
     */
    public function exploreAction(Request $request)
    {
        $form = $this->createForm(new BaseType(), null, ['action' => $this->generateUrl('place_base_order')])->createView();

        return compact('form');
    }

    /**
     * @Route("/ss", name="place_base_order")
     */
    public function placeBaseOrder(Request $request)
    {
        $baseOrder = new BaseOrder();
        $form = $this->createForm(new BaseOrder(), $baseOrder);
        $form->handleRequest($request);


        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();

            $em->persist($baseOrder);

            $em->flush();
        }

        $this->addFlash('success', 'You have successfully placed an order on IMPERIUMDESIGN!');
    }
}
