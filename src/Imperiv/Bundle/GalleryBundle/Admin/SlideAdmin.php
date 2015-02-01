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
        $formMapper->with('Slide')
            ->add('imageContent')
            ->add('textContent', 'textarea', ['required' => false])
            ->add('displayOrder')
            ->add('parentGallery', 'entity', ['class' => 'Imperiv\Bundle\GalleryBundle\Entity\GalleryPage'])
        ->end();
        
        if ($this->getSubject()->getTextContent() === NULL) {
            $formMapper->with('Transparent Zone')
                ->add('transparentZoneOpacity', 'number', ['label' => 'Opacity', 'required' => false])
                ->add('transparentZoneWidth', 'integer', ['label' => 'Width', 'required' => false])
                ->add('transparentZoneColor', 'text', ['label' => 'Color', 'required' => false])
                ->add('transparentZonePosition', 'integer', ['label' => 'Position', 'required' => false])
            ->end();
        }
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
