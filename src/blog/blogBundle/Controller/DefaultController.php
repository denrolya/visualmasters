<?php

namespace blog\blogBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class DefaultController extends Controller
{
    public function indexAction($name)
    {
        return $this->render('blogblogBundle:Default:index.html.twig', array('name' => $name));
    }
}
