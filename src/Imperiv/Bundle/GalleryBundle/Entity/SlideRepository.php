<?php

namespace Imperiv\Bundle\GalleryBundle\Entity;

use Doctrine\ORM\EntityRepository;

use Imperiv\Bundle\GalleryBundle\Entity\GalleryPage,
    Imperiv\Bundle\GalleryBundle\Entity\Slide;

/**
 * SlideRepository
 */
class SlideRepository extends EntityRepository
{
    public function findLastSlideInGallery(GalleryPage $parentGallery)
    {
        $qb = $this->createQueryBuilder('s')
            ->select('s')
            ->where('s.parentGallery = :parent_gallery')
            ->orderBy('s.displayOrder', 'DESC')
            ->setParameter('parent_gallery', $parentGallery)
            ->setFirstResult(0)->setMaxResults(1); // Neither one method except this helped to get only first result
        
        return $qb->getQuery()->getResult()[0];
    }
    
    public function getNextSlideId()
    {
        $this->getEntityManager()->createQuery();
        
        //        Query to select ID needed
        //        "select min(`s`.`id`) + 1 as `start`
        //        from `slides` as `s`
        //        left outer join `slides` as `s2` on `s`.`id` + 1 = `s2`.`id`
        //        where `s2`.`id` is null;"
    }
}
