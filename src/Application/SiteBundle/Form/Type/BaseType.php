<?php

namespace Application\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class BaseType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('full_name', 'text', [
            'label' => false,
            'attr' => [
                'placeholder' => 'Your name...'
            ]
        ])
        ->add('email', 'email', [
            'label' => false,
            'attr' => [
                'placeholder' => 'E-mail'
            ]
        ])
        ->add('phone', 'number', [
            'label' => false,
            'attr' => [
                'placeholder' => 'Phone number'
            ]
        ])
        ->add('address', 'text', [
            'label' => false,
            'attr' => [
                'placeholder' => 'Address'
            ]
        ])
        ->add('postal', 'text', [
            'label' => false,
            'attr' => [
                'placeholder' => 'Postal code'
            ]
        ])
        ->add('comments', 'textarea', [
            'label' => false,
            'attr' => [
                'placeholder' => 'Comments on order'
            ]
        ]);
    }

    public function getName()
    {
        return 'base';
    }
}