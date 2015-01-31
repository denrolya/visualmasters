<?php

namespace Imperiv\Bundle\GalleryBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;

class GalleryPageAdmin extends Admin
{
    protected function configureFormFields(FormMapper $formMapper)
    {
        $formMapper->add('pageName')
                ->add('slidesTimeout', 'text', ['required' => false])
                ->add('metaTitle')
                ->add('metaKeywords', 'text', ['required' => false])
                ->add('metaDescription', 'text', ['required' => false]);
    }
    
    protected function configureDatagridFilters(DatagridMapper $datagridMapper)
    {
        $datagridMapper->add('pageName')
                ->add('metaTitle')
                ->add('slidesTimeout');
    }
    
    protected function configureListFields(ListMapper $listMapper)
    {
        $listMapper
            ->add('pageName')
            ->add('metaTitle')
            ->add('slidesTimeout')
            ->add('metaKeywords')
            ->add('metaDescription')
        ;
    }
}