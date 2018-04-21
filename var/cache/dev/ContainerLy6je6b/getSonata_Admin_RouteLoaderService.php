<?php

use Symfony\Component\DependencyInjection\Argument\RewindableGenerator;

// This file has been auto-generated by the Symfony Dependency Injection Component for internal use.
// Returns the public 'sonata.admin.route_loader' shared service.

include_once $this->targetDirs[3].'/vendor/symfony/symfony/src/Symfony/Component/Config/Loader/LoaderInterface.php';
include_once $this->targetDirs[3].'/vendor/symfony/symfony/src/Symfony/Component/Config/Loader/Loader.php';
include_once $this->targetDirs[3].'/vendor/sonata-project/admin-bundle/src/Route/AdminPoolLoader.php';

return $this->services['sonata.admin.route_loader'] = new \Sonata\AdminBundle\Route\AdminPoolLoader(${($_ = isset($this->services['sonata.admin.pool']) ? $this->services['sonata.admin.pool'] : $this->getSonata_Admin_PoolService()) && false ?: '_'}, array(0 => 'sonata.media.admin.media', 1 => 'sonata.media.admin.gallery', 2 => 'sonata.media.admin.gallery_has_media', 3 => 'sonata.user.admin.user', 4 => 'sonata.user.admin.group', 5 => 'sonata.admin.gallery_page', 6 => 'sonata.admin.slide', 7 => 'sonata.admin.orders', 8 => 'sonata.admin.order_items', 9 => 'sonata.admin.video'), $this);