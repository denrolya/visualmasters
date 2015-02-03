<?php

namespace Imperiv\Bundle\GalleryBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;

use Imperiv\Bundle\GalleryBundle\Entity\Slide;

class SlideAdmin extends Admin 
{
    protected function configureFormFields(FormMapper $formMapper)
    {
        $formMapper->with('Slide')
            ->add('imageContent', 'sonata_type_model_list', [], ['link_parameters' => ['context' => 'default', 'provider' => 'sonata.media.provider.image']])
            ->add('parentGallery', 'entity', ['class' => 'Imperiv\Bundle\GalleryBundle\Entity\GalleryPage'])
            ->add('displayOrder')
            ->add('textContent', 'textarea', ['required' => false, 'attr' => ['class' => 'tinymce']])
        ->end();
        
        if ($this->getSubject()->getTextContent() !== NULL) {
            $formMapper->with('Transparent Zone')
                ->add('transparentZoneOpacity', 'number', [
                    'label' => 'Opacity',
                    'required' => false,
                    'data' => Slide::DEFAULT_TRANSP_ZONE_OPACITY
                    ])
                ->add('transparentZoneWidth', 'integer', [
                    'label' => 'Width',
                    'required' => false,
                    'data' => Slide::DEFAULT_TRANSP_ZONE_WIDTH
                    ])
                ->add('transparentZoneColor', 'text', [
                    'label' => 'Color',
                    'required' => false,
                    'data' => Slide::DEFAULT_TRANSP_ZONE_COLOR
                    ])
                ->add('transparentZonePosition', 'integer', [
                    'label' => 'Position',
                    'required' => false,
                    'data' => Slide::DEFAULT_TRANSP_ZONE_POSITION
                    ])
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
            ->addIdentifier('id')
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
