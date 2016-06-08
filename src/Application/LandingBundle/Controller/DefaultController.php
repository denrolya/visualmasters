<?php

namespace Application\LandingBundle\Controller;

use Application\LandingBundle\Entity\BaseOrder;
use Application\LandingBundle\Form\BaseOrderType;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

class DefaultController extends Controller
{
    /**
     * @Route("/")
     * @Template()
     */
    public function indexAction()
    {
        $order = new BaseOrder();
        $form = $this->createForm(new BaseOrderType(), $order)->createView();

        return compact('form');
    }
}
