<?php

namespace Application\LandingBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;
use Sonata\AdminBundle\Route\RouteCollection;
use Sonata\AdminBundle\Show\ShowMapper;

class OrderItemAdmin extends Admin
{
    protected function configureFormFields(FormMapper $formMapper)
    {
        $formMapper
            ->add('quantity')
            ->add('description')
            ->add('unitPrice')
            ->add('officeCharge', 'integer', ['attr' => ['min' => 0, 'max' => 100]])
            ;
    }

    protected function configureShowFields(ShowMapper $sm)
    {
        $sm
            ->add('quantity')
            ->add('description')
            ->add('unitPrice')
            ->add('officeCharge')
            ->add('totalPrice')
            ->add('order')
        ;
    }
}
