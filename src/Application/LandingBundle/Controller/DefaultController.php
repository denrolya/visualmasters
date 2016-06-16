<?php

namespace Application\LandingBundle\Controller;

use Application\LandingBundle\Entity\BaseOrder;
use Application\LandingBundle\Form\BaseOrderType;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="index")
     * @Template()
     */
    public function indexAction()
    {
        $order = new BaseOrder();
        $form = $this->createForm(new BaseOrderType(), $order, ['action' => $this->generateUrl('process_order')])->createView();

        return compact('form');
    }

    /**
     * @Route("/order", name="process_order")
     */
    public function processOrderAction(Request $request)
    {
        $order = new BaseOrder();
        $form = $this->createForm(new BaseOrderType(), $order);
        $form->handleRequest($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();

            $em->persist($order);

            $em->flush();

            $this->addFlash('success', 'You have successfully placed an order on VisualMasters!');

            $message = \Swift_Message::newInstance()
                ->setSubject('[New] Order was successfully submitted!')
                ->setFrom('no-reply@visualmasters.co.uk')
                ->setTo($order->getEmail())
                ->setBody($order->getComments(), 'text/html');

            $failedRecipients = [];

            $this->get('mailer')->send($message, $failedRecipients);

            return $this->redirectToRoute('index');
        }
    }
}
