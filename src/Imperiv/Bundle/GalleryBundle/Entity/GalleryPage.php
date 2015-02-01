<?php

namespace Imperiv\Bundle\GalleryBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

use Doctrine\Common\Collections\ArrayCollection;

/**
 * Page
 *
 * @ORM\Table()
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
     * @ORM\OneToMany(targetEntity="Imperiv\Bundle\GalleryBundle\Entity\Slide", mappedBy="parentGallery", orphanRemoval=true)
     */
    protected $slides;

    public function __construct()
    {
        $this->slides = new ArrayCollection();
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
     * @param \Imperiv\Bundle\GalleryBundle\Entity\Slide $slides
     * @return GalleryPage
     */
    public function addSlide(\Imperiv\Bundle\GalleryBundle\Entity\Slide $slides)
    {
        $this->slides[] = $slides;

        return $this;
    }

    /**
     * Remove slides
     *
     * @param \Imperiv\Bundle\GalleryBundle\Entity\Slide $slides
     */
    public function removeSlide(\Imperiv\Bundle\GalleryBundle\Entity\Slide $slides)
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
    
    public function __toString()
    {
        return $this->pageName;
    }
}
