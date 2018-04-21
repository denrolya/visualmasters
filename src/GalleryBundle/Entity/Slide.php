<?php

namespace GalleryBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Slide
 *
 * @ORM\Table(name="slide")
 * @ORM\Entity(repositoryClass="GalleryBundle\Entity\SlideRepository")
 */
class Slide
{
    const REPOSITORY_CLASS = "GalleryBundle:Slide";
    const DEFAULT_TRANSP_ZONE_OPACITY = 0.7;
    const DEFAULT_TRANSP_ZONE_WIDTH = 280;
    const DEFAULT_TRANSP_ZONE_POSITION = 20;
    const DEFAULT_TRANSP_ZONE_COLOR = "000000";
    const DEFAULT_TRANSP_ZONE_CLOSABLE = false;
    
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
     * @ORM\JoinColumn(name="image_content", referencedColumnName="id", nullable=false)
     */
    private $imageContent;

    /**
     * @var string
     *
     * @ORM\Column(name="text_content", type="text", nullable=true)
     */
    private $textContent;

    /**
     * @var integer
     *
     * @ORM\Column(name="display_order", type="string", length=6)
     */
    private $displayOrder;
    
    /**
     * @ORM\ManyToOne(targetEntity="GalleryBundle\Entity\GalleryPage", inversedBy="slides", cascade={"persist"})
     * @ORM\JoinColumn(name="gallery_page", referencedColumnName="id")
     */
    private $parentGallery;
    
    /**
     * @var boolean
     * 
     * @ORM\Column(name="transparent_zone_params", type="string", length=255)
     */
    private $transparentZoneParameters;

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
     * @param \GalleryBundle\Entity\GalleryPage $parentGallery
     * @return Slide
     */
    public function setParentGallery(\GalleryBundle\Entity\GalleryPage $parentGallery = null)
    {
        $this->parentGallery = $parentGallery;

        return $this;
    }

    /**
     * Get parentGallery
     *
     * @return \GalleryBundle\Entity\GalleryPage
     */
    public function getParentGallery()
    {
        return $this->parentGallery;
    }
    
    /**
     * Set transparentZoneParameters
     *
     * @param string $transparentZoneParameters
     * @return Slide
     */
    public function setTransparentZoneParameters($transparentZoneParameters)
    {
        $this->transparentZoneParameters = $transparentZoneParameters;

        return $this;
    }

    /**
     * Get transparentZoneParameters
     *
     * @return string 
     */
    public function getTransparentZoneParameters()
    {
        return $this->transparentZoneParameters;
    }
    
    public function __toString() {
        return "Slide #" . (string)$this->getId();
    }
}
