<?php

namespace SiteBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Show\ShowMapper;

class OrderItemAdmin extends Admin
{
    protected function configureFormFields(FormMapper $formMapper)
    {
        $formMapper
            ->add('quantity')
            ->add('description')
            ->add('unitPrice', 'number', ['scale' => 2])
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
