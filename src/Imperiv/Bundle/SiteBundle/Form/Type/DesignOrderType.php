<?php

namespace Imperiv\Bundle\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class DesignOrderType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('subcategory', 'choice', [
                'choices' => [
                    "Logotypes" => "Logotypes",
                    "Corporate identity" => "Corporate identity",
                    "Packaging design" => "Packaging design",
                    "Interfaces" => "Interfaces",
                    "Technical design" => "Technical design",
                    "Presentations" => "Presentations",
                    "Application interfaces design" => "Application interfaces design",
                    "Info-graphics" => "Info-graphics"
                ],
                'label' => false,
                'empty_value' => 'Subcategory'
            ])
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
                    'placeholder' => 'Phonenumber'
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
            ->add('use_3d_graphics', 'checkbox')
            ->add('style_example', 'file')
            ->add('color_psychology', 'checkbox')
            ->add('color_preferences', 'choice', [
                'label' => false,
                'choices' => [
                    'example1' => 'example 1',
                    'example2' => 'example 2',
                    'example3' => 'example 3',
                ],
                'empty_value' => 'Color preferences'
            ])
            ->add('comments', 'textarea', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Comments'
                ]
            ]);
//            ->add('save', 'submit', ['label' => 'Place an order']);
    }

    public function getName()
    {
        return 'design_order';
    }
}