<?php

use Symfony\Component\DependencyInjection\Argument\RewindableGenerator;

// This file has been auto-generated by the Symfony Dependency Injection Component for internal use.
// Returns the private 'sonata.templating.name_parser' shared service.

include_once $this->targetDirs[3].'/vendor/sonata-project/block-bundle/src/Templating/TemplateNameParser.php';

return $this->services['sonata.templating.name_parser'] = new \Sonata\BlockBundle\Templating\TemplateNameParser(${($_ = isset($this->services['kernel']) ? $this->services['kernel'] : $this->get('kernel')) && false ?: '_'});