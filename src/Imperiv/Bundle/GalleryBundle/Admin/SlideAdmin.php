<?php

namespace Imperiv\Bundle\GalleryBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;

class SlideAdmin extends Admin 
{
    protected function configureFormFields(FormMapper $formMapper)
    {
//        $formMapper;
    }
    
    protected function configureDatagridFilters(DatagridMapper $datagridMapper)
    {
//        $datagridMapper;
    }
    
    protected function configureListFields(ListMapper $listMapper)
    {
        $listMapper
            ->addIdentifier('parentGallery')
            ->add('displayOrder')
            ->addIdentifier('imageContent')
            ->add('textContent')
            ->add('transparentZoneOpacity')
            ->add('transparentZoneWidth')
            ->add('transparentZoneColor')
            ->add('transparentZonePosition')
        ;
    }
}
