<?php

namespace Imperiv\Bundle\GalleryBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Slide
 *
 * @ORM\Table(name="slides")
 * @ORM\Entity(repositoryClass="Imperiv\Bundle\GalleryBundle\Entity\SlideRepository")
 */
class Slide
{
    const REPOSITORY_CLASS = "ImperivGalleryBundle:Slide";
    const DEFAULT_TRANSP_ZONE_OPACITY = 0.7;
    const DEFAULT_TRANSP_ZONE_WIDTH = 280;
    const DEFAULT_TRANSP_ZONE_POSITION = 20;
    const DEFAULT_TRANSP_ZONE_COLOR = "000000";
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;
    
    /**
     * @var \Application\Sonata\MediaBundle\Entity\Media
     * @ORM\OneToOne(targetEntity="Application\Sonata\MediaBundle\Entity\Media", cascade={"persist", "remove"})
     * @ORM\JoinColumn(name="image_content", referencedColumnName="id")
     */
    private $imageContent;

    /**
     * @var string
     *
     * @ORM\Column(name="text_content", type="text", nullable=true)
     */
    private $textContent;

    /**
     * @var float
     *
     * @ORM\Column(name="transparent_zone_opacity", type="float", nullable=true)
     */
    private $transparentZoneOpacity;

    /**
     * @var integer
     *
     * @ORM\Column(name="transparent_zone_width", type="integer", nullable=true)
     */
    private $transparentZoneWidth;

    /**
     * @var integer
     *
     * @ORM\Column(name="transparent_zone_position", type="integer", nullable=true)
     */
    private $transparentZonePosition;

    /**
     * @var string
     *
     * @ORM\Column(name="transparent_zone_color", type="string", length=6, nullable=true)
     */
    private $transparentZoneColor;

    /**
     * @var integer
     *
     * @ORM\Column(name="display_order", type="string", length=6, nullable=true)
     */
    private $displayOrder;

    /**
     * @ORM\ManyToOne(targetEntity="Imperiv\Bundle\GalleryBundle\Entity\GalleryPage", inversedBy="slides", cascade={"persist"})
     * @ORM\JoinColumn(name="gallery_page", referencedColumnName="id")
     */
    private $parentGallery;


    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set imageContent
     *
     * @param \Application\Sonata\MediaBundle\Entity\Media $imageContent
     * @return Slide
     */
    public function setImageContent(\Application\Sonata\MediaBundle\Entity\Media $imageContent)
    {
        $this->imageContent = $imageContent;

        return $this;
    }

    /**
     * Get imageContent
     *
     * @return \Application\Sonata\MediaBundle\Entity\Media
     */
    public function getImageContent()
    {
        return $this->imageContent;
    }

    /**
     * Set textContent
     *
     * @param string $textContent
     * @return Slide
     */
    public function setTextContent($textContent)
    {
        $this->textContent = $textContent;

        return $this;
    }

    /**
     * Get textContent
     *
     * @return string 
     */
    public function getTextContent()
    {
        return $this->textContent;
    }

    /**
     * Set transparentZoneOpacity
     *
     * @param float $transparentZoneOpacity
     * @return Slide
     */
    public function setTransparentZoneOpacity($transparentZoneOpacity = self::DEFAULT_TRANSP_ZONE_OPACITY)
    {
        $this->transparentZoneOpacity = $transparentZoneOpacity;

        return $this;
    }

    /**
     * Get transparentZoneOpacity
     *
     * @return float 
     */
    public function getTransparentZoneOpacity()
    {
        return $this->transparentZoneOpacity;
    }

    /**
     * Set transparentZoneWidth
     *
     * @param integer $transparentZoneWidth
     * @return Slide
     */
    public function setTransparentZoneWidth($transparentZoneWidth = self::DEFAULT_TRANSP_ZONE_WIDTH)
    {
        $this->transparentZoneWidth = $transparentZoneWidth;

        return $this;
    }

    /**
     * Get transparentZoneWidth
     *
     * @return integer 
     */
    public function getTransparentZoneWidth()
    {
        return $this->transparentZoneWidth;
    }

    /**
     * Set transparentZonePosition
     *
     * @param integer $transparentZonePosition
     * @return Slide
     */
    public function setTransparentZonePosition($transparentZonePosition = self::DEFAULT_TRANSP_ZONE_POSITION)
    {
        $this->transparentZonePosition = $transparentZonePosition;

        return $this;
    }

    /**
     * Get transparentZonePosition
     *
     * @return integer 
     */
    public function getTransparentZonePosition()
    {
        return $this->transparentZonePosition;
    }

    /**
     * Set transparentZoneColor
     *
     * @param string $transparentZoneColor
     * @return Slide
     */
    public function setTransparentZoneColor($transparentZoneColor = self::DEFAULT_TRANSP_ZONE_COLOR)
    {
        $this->transparentZoneColor = $transparentZoneColor;

        return $this;
    }

    /**
     * Get transparentZoneColor
     *
     * @return string 
     */
    public function getTransparentZoneColor()
    {
        return $this->transparentZoneColor;
    }

    /**
     * Set displayOrder
     *
     * @param integer $displayOrder
     * @return Slide
     */
    public function setDisplayOrder($displayOrder)
    {
        $this->displayOrder = $displayOrder;

        return $this;
    }

    /**
     * Get transparentZoneColor
     *
     * @return integer
     */
    public function getDisplayOrder()
    {
        return $this->displayOrder;
    }



    /**
     * Set parentGallery
     *
     * @param \Imperiv\Bundle\GalleryBundle\Entity\GalleryPage $parentGallery
     * @return Slide
     */
    public function setParentGallery(\Imperiv\Bundle\GalleryBundle\Entity\GalleryPage $parentGallery = null)
    {
        $this->parentGallery = $parentGallery;

        return $this;
    }

    /**
     * Get parentGallery
     *
     * @return \Imperiv\Bundle\GalleryBundle\Entity\GalleryPage 
     */
    public function getParentGallery()
    {
        return $this->parentGallery;
    }
}
