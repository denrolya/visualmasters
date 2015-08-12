<?php

namespace Imperiv\Bundle\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class VideoOrderType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('subcategory', 'choice', [
                'choices' => [
                    "Montage" => "Montage",
                    "Video design" => "Video design",
                    "Video presentation" => "Video presentation"
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
            ->add('max_video_length', 'number', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Maximal video length'
                ]
            ])
            ->add('format', 'choice', [
                'choices' => [
                    'DVD' => 'DVD',
                    'HD' => 'HD'
                ],
                'label' => false,
                'empty_value' => 'Format'
            ])
            ->add('music', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Music'
                ]
            ])
            ->add('titles', 'file')
            ->add('scenario', 'file')
            ->add('additional_effects', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Additional effects'
                ]
            ])
            ->add('materials_total_gbs', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Total GBs of materials'
                ]
            ])
            ->add('comments', 'textarea', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Comments'
                ]
            ]);
    }

    public function getName()
    {
        return 'design_order';
    }
}