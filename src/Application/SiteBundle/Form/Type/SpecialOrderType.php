<?php

namespace Application\SiteBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Application\SiteBundle\Form\Type\BaseOrderType;

class SpecialOrderType extends BaseOrderType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        parent::buildForm($builder, $options);
    }

    public function getName() { return 'special_order'; }
}