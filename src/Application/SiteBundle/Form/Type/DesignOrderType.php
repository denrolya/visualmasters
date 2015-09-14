<?php

namespace Application\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Application\SiteBundle\Form\Type\BaseType;

class DesignOrderType extends BaseType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        parent::buildForm($builder, $options);

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
            ]);
    }

    public function getName() { return 'design_order'; }
}