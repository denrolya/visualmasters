<?php

namespace Application\SiteBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;

class InteriorOrderAdmin extends Admin
{
    protected function configureFormFields(FormMapper $formMapper)
    {
    }

    protected function configureDatagridFilters(DatagridMapper $datagridMapper)
    {
    }

    protected function configureListFields(ListMapper $listMapper)
    {
        $listMapper
            ->addIdentifier('id')
            ->add('fullName')
            ->add('email')
            ->add('phone')
            ->add('address')
            ->add('postal')
            ->add('subcategory')
            ->add('designerConsultancy')
            ->add('mediaEquipIntegration')
            ->add('lightDesign')
            ->add('floorMaterial')
            ->add('ceilingMaterial')
            ->add('wallsMaterial')
            ->add('furniture')
            ->add('colorPsychology')
            ->add('classicColoristicsCanon')
            ->add('dominantColor')
            ->add('secondaryColor')
            ->add('birthDate')
            ->add('useFengShuiForPartner')
            ->add('styleExample')
            ->add('drawing')
            ->add('environmentPhoto')
        ;
    }
}
