<?php

namespace LandingBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;
use Sonata\AdminBundle\Route\RouteCollection;
use Sonata\AdminBundle\Show\ShowMapper;

class OrderAdmin extends Admin
{
    protected $datagridValues = [
        '_page' => 1,
        '_sort_order' => 'DESC',
        '_sort_by' => 'createdAt',
    ];

    protected function configureFormFields(FormMapper $formMapper)
    {
        $formMapper
            ->with('Order information')
                ->add('name')
                ->add('email')
                ->add('phonenumber')
                ->add('address')
                ->add('postal')
            ->end()
            ->with('Addition information')
                ->add('salesPerson')
                ->add('projectName')
                ->add('terms', 'choice', ['choices' => ['cash' => 'Cash', 'transfer' => 'Transfer']])
                ->add('deliveryDate', 'date')
            ->end()
            ->with('Invoice')
                ->add('invoiceDate', 'sonata_type_datetime_picker', [
                    'placeholder' => 'Date to be displayed in invoice for this order',
                    'label' => 'Invoice date'
                ])
            ->end()
            ->with('Order Items')
                ->add('items', 'sonata_type_collection', ['by_reference' => false, 'required' => true], [
                    'edit' => 'inline',
                    'inline' => 'table',
                    'sortable' => 'id'
                ])
            ->end()
            ;
    }

    protected function configureDatagridFilters(DatagridMapper $datagridMapper)
    {
    }

    protected function configureListFields(ListMapper $listMapper)
    {
        $listMapper
            ->addIdentifier('id')
            ->add('name')
            ->add('email')
            ->add('phonenumber')
            ->add('address')
            ->add('postal')
            ->add('createdAt')
            ->add('invoices', 'actions', [
                'template' => 'LandingBundle:CRUD:list__action_invoices.html.twig'
            ])
            ->add('_action', 'actions', [
                'actions' => [
                    'show'      => [],
                    'edit'      => [],
                    'delete'    => []
                ]
            ])
        ;
    }


    protected function configureShowFields(ShowMapper $sm)
    {
        $sm
            ->add('id')
            ->add('name')
            ->add('email')
            ->add('phonenumber')
            ->add('address')
            ->add('postal')
            ->add('comments')
            ->add('file')
            ->add('items')
        ;
    }

    protected function configureRoutes(RouteCollection $collection)
    {
        $collection->add('invoice_html', $this->getRouterIdParameter().'/invoice.html');
        $collection->add('invoice_pdf', $this->getRouterIdParameter().'/invoice.pdf');
//        $collection->clearExcept(['list', 'show', 'edit', 'delete', 'invoice']);
    }
}
