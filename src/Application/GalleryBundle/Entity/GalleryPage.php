<?php

namespace Application\GalleryBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

use Doctrine\Common\Collections\ArrayCollection;

/**
 * Page
 *
 * @ORM\Table(name="galleries")
 * @ORM\Entity()
 */
class GalleryPage
{
    
    const DEFAUlT_TIMEOUT = 18000;
    
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string
     *
     * @ORM\Column(name="page_name", type="string", length=255)
     */
    private $pageName;

    /**
     * @var string
     *
     * @ORM\Column(name="detailed_description", type="text", nullable=true)
     */
    private $detailedDescription;

    /**
     * @var string
     *
     * @ORM\Column(name="meta_title", type="string", length=255)
     */
    private $metaTitle;

    /**
     * @var string
     *
     * @ORM\Column(name="meta_keywords", type="text", nullable=true)
     */
    private $metaKeywords;

    /**
     * @var string
     *
     * @ORM\Column(name="meta_description", type="text", nullable=true)
     */
    private $metaDescription;
    
    /**
     * @var integer
     * 
     * @ORM\Column(name="slides_timeout", type="integer", options={"default":8000})
     */
    private $slidesTimeout;

    /**
     * @ORM\OneToMany(targetEntity="Slide", mappedBy="parentGallery", cascade={"persist", "remove"})
     * @ORM\OrderBy({"displayOrder" = "ASC"})
     */
    protected $slides;

    /**
     * @ORM\OneToMany(targetEntity="Application\SiteBundle\Entity\BaseOrder", mappedBy="category")
     */
    private $orders;

    public function __toString()
    {
        return $this->pageName;
    }

    public function __construct()
    {
        $this->slides = new ArrayCollection();
        $this->orders = new ArrayCollection();
    }

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
     * Set pageName
     *
     * @param string $pageName
     * @return Page
     */
    public function setPageName($pageName)
    {
        $this->pageName = $pageName;

        return $this;
    }

    /**
     * Get pageName
     *
     * @return string 
     */
    public function getPageName()
    {
        return $this->pageName;
    }

    /**
     * Set$detailedDescription
     *
     * @param string $detailedDescription
     * @return GalleryPage
     */
    public function setDetailedDescription($detailedDescription)
    {
        $this->detailedDescription= $detailedDescription;

        return $this;
    }

    /**
     * Get detailedDescription
     *
     * @return string
     */
    public function getDetailedDescription()
    {
        return $this->detailedDescription;
    }

    /**
     * Set metaTitle
     *
     * @param string $metaTitle
     * @return Page
     */
    public function setMetaTitle($metaTitle)
    {
        $this->metaTitle = $metaTitle;

        return $this;
    }

    /**
     * Get metaTitle
     *
     * @return string 
     */
    public function getMetaTitle()
    {
        return $this->metaTitle;
    }

    /**
     * Set metaKeywords
     *
     * @param string $metaKeywords
     * @return Page
     */
    public function setMetaKeywords($metaKeywords)
    {
        $this->metaKeywords = $metaKeywords;

        return $this;
    }

    /**
     * Get metaKeywords
     *
     * @return string 
     */
    public function getMetaKeywords()
    {
        return $this->metaKeywords;
    }

    /**
     * Set metaDescription
     *
     * @param string $metaDescription
     * @return Page
     */
    public function setMetaDescription($metaDescription)
    {
        $this->metaDescription = $metaDescription;

        return $this;
    }

    /**
     * Get metaDescription
     *
     * @return string 
     */
    public function getMetaDescription()
    {
        return $this->metaDescription;
    }

    /**
     * Add slides
     *
     * @param \Application\GalleryBundle\Entity\Slide $slides
     * @return GalleryPage
     */
    public function addSlide(\Application\GalleryBundle\Entity\Slide $slides)
    {
        $this->slides[] = $slides;

        return $this;
    }

    /**
     * Remove slides
     *
     * @param \Application\GalleryBundle\Entity\Slide $slides
     */
    public function removeSlide(\Application\GalleryBundle\Entity\Slide $slides)
    {
        $this->slides->removeElement($slides);
    }

    /**
     * Get slides
     *
     * @return \Doctrine\Common\Collections\Collection 
     */
    public function getSlides()
    {
        return $this->slides;
    }

    /**
     * Set slidesTimeout
     *
     * @param integer $slidesTimeout
     * @return GalleryPage
     */
    public function setSlidesTimeout($slidesTimeout = self::DEFAUlT_TIMEOUT)
    {
        $this->slidesTimeout = $slidesTimeout;

        return $this;
    }

    /**
     * Get slidesTimeout
     *
     * @return integer 
     */
    public function getSlidesTimeout()
    {
        return $this->slidesTimeout;
    }

    /**
     * Add orders
     *
     * @param \Application\SiteBundle\Entity\BaseOrder $orders
     * @return GalleryPage
     */
    public function addOrder(\Application\SiteBundle\Entity\BaseOrder $orders)
    {
        $this->orders[] = $orders;

        return $this;
    }

    /**
     * Remove orders
     *
     * @param \Application\SiteBundle\Entity\BaseOrder $orders
     */
    public function removeOrder(\Application\SiteBundle\Entity\BaseOrder $orders)
    {
        $this->orders->removeElement($orders);
    }

    /**
     * Get orders
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getOrders()
    {
        return $this->orders;
    }
}
