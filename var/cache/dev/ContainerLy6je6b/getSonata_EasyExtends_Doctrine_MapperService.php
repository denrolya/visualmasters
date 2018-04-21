<?php

use Symfony\Component\DependencyInjection\Argument\RewindableGenerator;

// This file has been auto-generated by the Symfony Dependency Injection Component for internal use.
// Returns the private 'sonata.easy_extends.doctrine.mapper' shared service.

include_once $this->targetDirs[3].'/vendor/doctrine/common/lib/Doctrine/Common/EventSubscriber.php';
include_once $this->targetDirs[3].'/vendor/sonata-project/easy-extends-bundle/src/Mapper/DoctrineORMMapper.php';

$this->services['sonata.easy_extends.doctrine.mapper'] = $instance = new \Sonata\EasyExtendsBundle\Mapper\DoctrineORMMapper(${($_ = isset($this->services['doctrine']) ? $this->services['doctrine'] : $this->getDoctrineService()) && false ?: '_'}, array());

$instance->addAssociation('Application\\Sonata\\MediaBundle\\Entity\\Media', 'mapOneToMany', array(0 => array('fieldName' => 'galleryHasMedias', 'targetEntity' => 'Application\\Sonata\\MediaBundle\\Entity\\GalleryHasMedia', 'cascade' => array(0 => 'persist'), 'mappedBy' => 'media', 'orphanRemoval' => false)));
$instance->addAssociation('Application\\Sonata\\MediaBundle\\Entity\\GalleryHasMedia', 'mapManyToOne', array(0 => array('fieldName' => 'gallery', 'targetEntity' => 'Application\\Sonata\\MediaBundle\\Entity\\Gallery', 'cascade' => array(0 => 'persist'), 'mappedBy' => NULL, 'inversedBy' => 'galleryHasMedias', 'joinColumns' => array(0 => array('name' => 'gallery_id', 'referencedColumnName' => 'id', 'onDelete' => 'CASCADE')), 'orphanRemoval' => false), 1 => array('fieldName' => 'media', 'targetEntity' => 'Application\\Sonata\\MediaBundle\\Entity\\Media', 'cascade' => array(0 => 'persist'), 'mappedBy' => NULL, 'inversedBy' => 'galleryHasMedias', 'joinColumns' => array(0 => array('name' => 'media_id', 'referencedColumnName' => 'id', 'onDelete' => 'CASCADE')), 'orphanRemoval' => false)));
$instance->addAssociation('Application\\Sonata\\MediaBundle\\Entity\\Gallery', 'mapOneToMany', array(0 => array('fieldName' => 'galleryHasMedias', 'targetEntity' => 'Application\\Sonata\\MediaBundle\\Entity\\GalleryHasMedia', 'cascade' => array(0 => 'persist'), 'mappedBy' => 'gallery', 'orphanRemoval' => true, 'orderBy' => array('position' => 'ASC'))));
$instance->addAssociation('Sonata\\UserBundle\\Entity\\BaseUser', 'mapManyToMany', array(0 => array('fieldName' => 'groups', 'targetEntity' => 'Sonata\\UserBundle\\Entity\\BaseGroup', 'cascade' => array(), 'joinTable' => array('name' => 'fos_user_user_group', 'joinColumns' => array(0 => array('name' => 'user_id', 'referencedColumnName' => 'id', 'onDelete' => 'CASCADE')), 'inverseJoinColumns' => array(0 => array('name' => 'group_id', 'referencedColumnName' => 'id', 'onDelete' => 'CASCADE'))))));

return $instance;