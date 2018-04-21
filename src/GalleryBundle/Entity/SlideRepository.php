<?php

namespace GalleryBundle\Entity;

use Doctrine\ORM\EntityRepository;

/**
 * SlideRepository
 */
class SlideRepository extends EntityRepository
{
    public function findNextSlidesIdInProvidedGallery(GalleryPage $galleryPage)
    {
        $em = $this->getEntityManager();
        $sql = "SELECT MIN(`s1`.`display_order`) + 1 AS `do` FROM `slides` AS `s1` "
                . "LEFT OUTER JOIN `slides` AS `s2` ON `s1`.`display_order` + 1 = `s2`.`display_order` "
                . "AND `s1`.`gallery_page` = `s2`.`gallery_page` WHERE `s2`.`display_order` is NULL AND `s1`.`gallery_page` = :galleryPage";
        $connection = $em->getConnection();
        $statement = $connection->prepare($sql);
        $statement->bindValue('galleryPage', $galleryPage->getId());
        $statement->execute();
        $result = $statement->fetchAll()[0]['do'];
        
        return $result === NULL ? 1 : $result;
    }    
}
