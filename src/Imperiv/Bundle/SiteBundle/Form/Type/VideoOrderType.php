<?php

namespace Imperiv\Bundle\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class VideoOrderType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('full_name')
            ->add('email')
            ->add('phone')
            ->add('address')
            ->add('postal')
            ->add('comments')
            ->add('use_3d_graphics')
            ->add('music')
            ->add('additional_effects')
            ->add('materials_total_gbs');
    }

    public function getName()
    {
        return 'design_order';
    }
}