<?php

namespace SiteBundle\Admin;

use Sonata\AdminBundle\Admin\Admin;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Datagrid\ListMapper,
    Sonata\AdminBundle\Datagrid\DatagridMapper;

use Cocur\Slugify\Slugify;

use SiteBundle\Entity\GalleryPage;

class GalleryPageAdmin extends Admin
{
    protected function configureFormFields(FormMapper $formMapper)
    {
        $formMapper
                ->add('title', null, ['label' => 'Title'])
                ->add('detailedDescription', 'textarea', [
                    'required' => false,
                    'attr' => ['class' => 'tinymce']
                ])
                ->add('slidesTimeout', 'text', ['data' => GalleryPage::DEFAUlT_TIMEOUT])
                ->add('metaKeywords', 'text', ['required' => false])
                ->add('metaDescription', 'text', ['required' => false]);
    }
    
    protected function configureDatagridFilters(DatagridMapper $datagridMapper)
    {
        $datagridMapper
                ->add('title')
                ->add('slidesTimeout');
    }
    
    protected function configureListFields(ListMapper $listMapper)
    {
        $listMapper
                ->addIdentifier('title', null, ['label' => 'Title'])
                ->addIdentifier('pageName', null, [
                    'label' => 'Link',
                    'template' => 'SiteBundle:Admin:fields/page_link.html.twig'
                ])
                ->add('slidesTimeout')
                ->add('metaKeywords')
                ->add('metaDescription');
    }

    public function preUpdate($galleryPage)
    {
        $slugify = new Slugify();
        $titleSlug = $slugify->slugify($galleryPage->getTitle());
        $galleryPage->setSlug($titleSlug);
    }

    public function prePersist($galleryPage)
    {
        $slugify = new Slugify();
        $titleSlug = $slugify->slugify($galleryPage->getTitle());
        $galleryPage->setSlug($titleSlug);
    }
}