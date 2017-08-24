<?php

namespace Application\LandingBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;
use Sonata\AdminBundle\Route\RouteCollection;
use Sonata\AdminBundle\Show\ShowMapper;

class OrderAdmin extends Admin
{
    protected function configureFormFields(FormMapper $formMapper)
    {
        $formMapper->add('name')
            ->add('email')
            ->add('phonenumber')
            ->add('address')
            ->add('postal')
            ->add('price')
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
            ->add('price', 'decimal', ['editable' => true])
            ->add('_action', null, [
                'actions' => [
                    'show'      => [],
                    'edit'      => [],
                    'delete'    => [],
                    'invoice'   => [
                        'template' => '::invoiceAction.html.twig'
                    ]
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
            ->add('price')
            ->add('postal')
            ->add('comments')
            ->add('file')
        ;
    }

    protected function configureRoutes(RouteCollection $collection)
    {
        $collection->add('invoice', $this->getRouterIdParameter().'/invoice');
        $collection->clearExcept(['list', 'show', 'edit', 'delete', 'invoice']);
    }
}
