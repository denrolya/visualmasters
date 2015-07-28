<?php

namespace Imperiv\Bundle\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class DesignOrderType extends AbstractType
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
            ->add('max_video_length')
            ->add('format')
            ->add('color_preferences');
    }

    public function getName()
    {
        return 'design_order';
    }
}