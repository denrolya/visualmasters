<?php

namespace Imperiv\Bundle\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class InteriorOrderType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('subcategory', 'choice', [
                'choices' => [
                    "Interiors" => "Interiors",
                    "Landscape design/Master plan" => "Landscape design/Master plan",
                    "3D modeling" => "3D modeling",
                    "Exteriors" => "Exteriors",
                    "3D illustrations" => "3D illustrations",
                    "Project drawings\schemes" => "Project drawings\schemes",
                    "Constructions" => "Constructions"
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
            ->add('designer_consultancy', 'checkbox')
            ->add('media_equip_integration', 'checkbox')
            ->add('light_design', 'checkbox')
            ->add('floor_material', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Floor material'
                ]
            ])
            ->add('ceiling_material', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Ceiling material'
                ]
            ])
            ->add('walls_material', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Walls material'
                ]
            ])
            ->add('furniture', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Furniture'
                ]
            ])
            ->add('color_psychology', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Color psychology'
                ]
            ])
            ->add('classic_coloristics_canon', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Classic coloristics canons'
                ]
            ])
            ->add('dominant_color', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Dominant color'
                ]
            ])
            ->add('secondary_color', 'text', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Secondary color'
                ]
            ])
            ->add('use_feng_shui', 'checkbox')
            ->add('birth_date', 'datetime', [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Birthdate'
                ]
            ])
            ->add('use_feng_shui_for_partner', 'checkbox')
            ->add('style_example', 'file')
            ->add('drawing', 'file')
            ->add('environment_photos', 'file')
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