<?php
namespace Application\LandingBundle\Controller;

use Sonata\AdminBundle\Controller\CRUDController;
use Symfony\Component\HttpFoundation\RedirectResponse;

class AdminController extends CRUDController
{
    public function invoiceAction()
    {
        $order = $this->admin->getSubject();

        return new RedirectResponse($this->admin->generateUrl('list'));
    }
}