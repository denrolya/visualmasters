<?php

namespace Application\LandingBundle\Controller;

use Sonata\AdminBundle\Controller\CRUDController as Controller;
use Symfony\Component\HttpFoundation\Response;

class CRUDController extends Controller
{
    public function invoiceHtmlAction()
    {
        return $this->render('::invoice.html.twig');
    }

    public function invoicePdfAction()
    {
        $pageUrl = $this->generateUrl('admin_application_landing_order_invoice_html', [
            'id' => $this->get('request')->get($this->admin->getIdParameter())
        ], true); // use absolute path!

        return new Response(
            $this->get('knp_snappy.pdf')->getOutput($pageUrl),
            200,
            [
                'Content-Type'          => 'application/pdf',
                'Content-Disposition'   => 'attachment; filename="invoice.pdf"'
            ]
        );
    }
}