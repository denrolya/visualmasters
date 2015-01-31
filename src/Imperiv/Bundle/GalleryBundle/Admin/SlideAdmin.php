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
        $formMapper->add('imageContent')
            ->add('textContent')
            ->add('displayOrder')
            ->add('parentGallery', 'entity', ['class' => 'Imperiv\Bundle\GalleryBundle\Entity\GalleryPage'])
            ->add('transparentZoneOpacity', 'text', ['required' => false])
            ->add('transparentZoneWidth', 'text', ['required' => false])
            ->add('transparentZoneColor', 'text', ['required' => false])
            ->add('transparentZonePosition', 'text', ['required' => false]);
    }
    
    protected function configureDatagridFilters(DatagridMapper $datagridMapper)
    {
        $datagridMapper->add('parentGallery')
                ->add('displayOrder');
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
