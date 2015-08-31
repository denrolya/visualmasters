<?php

namespace Application\SiteBundle\Twig;

class Extension extends \Twig_Extension
{
    public function getFilters()
    {
        return [
            new \Twig_SimpleFilter('unserialize', 'unserialize')
        ];
    }
    
    public function getName() {
        return 'global_extension';
    }
}
