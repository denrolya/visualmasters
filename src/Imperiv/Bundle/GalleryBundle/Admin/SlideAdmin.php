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
            ->add('imageContent', 'sonata_type_model_list', [], ['link_parameters' => [
                    'context' => 'default',
                    'provider' => 'sonata.media.provider.image',
                    'required' => false
                    ]
                ]
            )
            ->add('parentGallery', 'entity', ['class' => 'Imperiv\Bundle\GalleryBundle\Entity\GalleryPage'])
            ->add('displayOrder', 'text', ['required' => false])
            ->add('textContent', 'textarea', [
                'required' => false, 
                'attr' => ['class' => 'tinymce']
            ])
        ->end();

        if ($this->getSubject()->getTextContent() !== NULL) {
            $transparentZoneParameters = unserialize($this->getSubject()->getTransparentZoneParameters());
            $formMapper->with('Transparent Zone')
                ->add('orientation', 'choice', [
                    'choices' => [
                        1 => 'Vertical',
                        2 => 'Horizontal',
                    ],
                    'data' => $transparentZoneParameters['orientation'],
                    'mapped' => false
                    ])
            ->add('size', 'integer', [
                    'label' => 'Height/Width',
                    'required' => false,
                    'data' => $transparentZoneParameters['size'],
                    'mapped' => false
                    ])
            ->add('opacity', 'number', [
                    'label' => 'Opacity',
                    'required' => false,
                    'data' => $transparentZoneParameters['opacity'],
                    'mapped' => false
                    ])
                ->add('color', 'text', [
                    'label' => 'Color',
                    'required' => false,
                    'attr' => ['class' => 'colorpicker'],
                    'data' => $transparentZoneParameters['color'],
                    'mapped' => false
                    ])
                ->add('position', 'integer', [
                    'label' => 'Position',
                    'required' => false,
                    'data' => $transparentZoneParameters['position'],
                    'mapped' => false
                    ])
                ->add('closable', 'checkbox', [
                    'label' => 'Closable',
                    'required' => false,
                    'data' => $transparentZoneParameters['closable'],
                    'mapped' => false
                    ])
            ->end();
        }
    }
    
    protected function configureDatagridFilters(DatagridMapper $datagridMapper)
    {
        $datagridMapper
                ->add('parentGallery')
                ->add('displayOrder')
                ->add('textContent');
    }
    
    protected function configureListFields(ListMapper $listMapper)
    {
        $listMapper
            ->addIdentifier('parentGallery')
            ->add('displayOrder')
            ->addIdentifier('content', null, ['template' => 'ImperivGalleryBundle:Admin:fields/image_preview.html.twig'])
        ;
    }
    
    public function prePersist($object) {
        parent::prePersist($object);
        
        $em = $this->getConfigurationPool()->getContainer()->get('doctrine.orm.entity_manager');
        
        $defaultParams = [
            'opacity' => Slide::DEFAULT_TRANSP_ZONE_OPACITY,
            'orientation' => 1,
            'size' => Slide::DEFAULT_TRANSP_ZONE_WIDTH,
            'color' => Slide::DEFAULT_TRANSP_ZONE_COLOR,
            'position' => Slide::DEFAULT_TRANSP_ZONE_POSITION,
            'closable' => Slide::DEFAULT_TRANSP_ZONE_CLOSABLE
        ];
        
        $object->setTransparentZoneParameters(serialize($defaultParams));
        
        // Set default transparent zone parameters
        
        if ($object->getDisplayOrder() === NULL) {
            $displayOrder = $em->getRepository(Slide::REPOSITORY_CLASS)
                    ->findNextSlidesIdInProvidedGallery($object->getParentGallery());

            $object->setDisplayOrder($displayOrder);
        }
    }
    
    public function preUpdate($object)
    {
        if ($this->getForm()->has('orientation')) {
            $transparentZoneParameters = [];

            $transparentZoneProperties = ['orientation', 'size', 'opacity', 'color', 'position', 'closable'];

            foreach ($transparentZoneProperties as $property) {
                $transparentZoneParameters[$property] = $this->getForm()->get($property)->getData();
            }

            $object->setTransparentZoneParameters(serialize($transparentZoneParameters));
        }

    }
}
