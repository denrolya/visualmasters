<?php

namespace Imperiv\Bundle\GalleryBundle\Entity;

use Doctrine\ORM\EntityRepository;

use Imperiv\Bundle\GalleryBundle\Entity\GalleryPage,
    Imperiv\Bundle\GalleryBundle\Entity\Slide;

use Doctrine\ORM\Query\ResultSetMappingBuilder;

/**
 * SlideRepository
 */
class SlideRepository extends EntityRepository
{
    public function findSlidesInGalleryApplyingDisplayOrder($galleryPage)
    {
        $em = $this->getEntityManager();
        
        $qb = $em->createQueryBuilder('s')
                ->select('s')
                ->from('ImperivGalleryBundle:Slide', 's')
                ->where('s.parentGallery = :galleryPage')
                ->setParameter('galleryPage', $galleryPage)
                ->orderBy('s.displayOrder');
        
        return $qb->getQuery()->getResult();
    }
    
    public function findNextSlidesIdInProvidedGallery($galleryPageId)
    {
        $em = $this->getEntityManager();
        $sql = "SELECT MIN(`s1`.`display_order`) + 1 AS `do` FROM `slides` AS `s1` "
                . "LEFT OUTER JOIN `slides` AS `s2` ON `s1`.`display_order` + 1 = `s2`.`display_order` "
                . "WHERE `s2`.`display_order` is NULL AND `s1`.`gallery_page` = :galleryPage";
        $connection = $em->getConnection();
        $statement = $connection->prepare($sql);
        $statement->bindValue('galleryPage', $galleryPageId);
        $statement->execute();
        $result = $statement->fetchAll()[0]['do'];
        
        return $result;
    }    
}
