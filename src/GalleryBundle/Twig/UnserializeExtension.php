<?php

namespace GalleryBundle\Twig;

use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;

class UnserializeExtension extends AbstractExtension
{
    public function getFilters()
    {
        return [
            new TwigFilter('unserialize', [$this, 'unserializeFilter']),
        ];
    }

    public function unserializeFilter($string)
    {
        return unserialize($string);
    }
}