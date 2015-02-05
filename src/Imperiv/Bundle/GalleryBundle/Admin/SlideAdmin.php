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
            ->add('displayOrder', 'text', ['required' => false])
            ->add('textContent', 'textarea', ['required' => false, 'attr' => ['class' => 'tinymce']])
        ->end();
        
        if ($this->getSubject()->getTextContent() !== NULL) {
            $formMapper->with('Transparent Zone')
                ->add('transparentZoneOpacity', 'number', [
                    'label' => 'Opacity',
                    'required' => false
                    ])
                ->add('transparentZoneWidth', 'integer', [
                    'label' => 'Width',
                    'required' => false
                    ])
                ->add('transparentZoneColor', 'text', [
                    'label' => 'Color',
                    'required' => false,
                    'attr' => ['class' => 'colorpicker']
                    ])
                ->add('transparentZonePosition', 'integer', [
                    'label' => 'Position',
                    'required' => false
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
    
    public function prePersist($object) {
        parent::prePersist($object);
        
        $em = $this->getConfigurationPool()->getContainer()->get('doctrine.orm.entity_manager');
        
        if ($object->getDisplayOrder() === NULL) {
            $lastSlideInGallery = $em->getRepository(Slide::REPOSITORY_CLASS)
                    ->findLastSlideInGallery($object->getParentGallery());
            
            $object->setDisplayOrder($lastSlideInGallery->getDisplayOrder() + 1);
        }
        
        $object->setTransparentZoneOpacity(Slide::DEFAULT_TRANSP_ZONE_OPACITY)
                ->setTransparentZoneWidth(Slide::DEFAULT_TRANSP_ZONE_WIDTH)
                ->setTransparentZoneColor(Slide::DEFAULT_TRANSP_ZONE_COLOR)
                ->setTransparentZonePosition(Slide::DEFAULT_TRANSP_ZONE_POSITION);
    }
}
