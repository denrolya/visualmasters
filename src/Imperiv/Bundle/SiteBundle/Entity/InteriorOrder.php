<?php

namespace Imperiv\Bundle\SiteBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 */
class InteriorOrder extends BaseOrder
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var boolean
     *
     * @ORM\Column(name="designer_consultancy", type="boolean", options={"nullable" : true})
     */
    private $designerConsultancy;

    /**
     * @var boolean
     *
     * @ORM\Column(name="media_equip_integration", type="boolean", options={"nullable" : true})
     */
    private $mediaEquipIntegration;

    /**
     * @var string
     *
     * @ORM\Column(name="light_designs", type="boolean", options={"nullable" : true})
     */
    private $lightDesigns;

    /**
     * @var string
     *
     * @ORM\Column(name="floor_material", type="string", length=255, options={"nullable" : true})
     */
    private $floorMaterial;

    /**
     * @var string
     *
     * @ORM\Column(name="ceiling_material", type="string", length=255, options={"nullable" : true})
     */
    private $ceilingMaterial;

    /**
     * @var string
     *
     * @ORM\Column(name="walls_material", type="string", length=255, options={"nullable" : true})
     */
    private $wallsMaterial;

    /**
     * @var string
     *
     * @ORM\Column(name="furniture", type="string", length=255, options={"nullable" : true})
     */
    private $furniture;

    /**
     * @var string
     *
     * @ORM\Column(name="color_psychology", type="string", length=255, options={"nullable" : true})
     */
    private $colorPsychology;

    /**
     * @var string
     *
     * @ORM\Column(name="classic_coloristics_canon", type="boolean", options={"nullable" : true})
     */
    private $classicColoristicsCanon;

    /**
     * @var string
     *
     * @ORM\Column(name="dominant_color", type="string", length=6, options={"nullable" : true})
     */
    private $dominantColor;

    /**
     * @var string
     *
     * @ORM\Column(name="secondary_color", type="string", length=6, options={"nullable" : true})
     */
    private $secondaryColor;

    /**
     * @var string
     *
     * @ORM\Column(name="use_feng_shui", type="boolean", options={"nullable" : true})
     */
    private $useFengShui;

    /**
     * @var string
     *
     * @ORM\Column(name="birth_date", type="datetime", options={"nullable" : true})
     */
    private $birthDate;

    /**
     * @var string
     *
     * @ORM\Column(name="use_feng_shui_for_partner", type="datetime", options={"nullable" : true})
     */
    private $useFengShuiForPartner;

    /**
     * @var string
     *
     * @ORM\Column(name="comments", type="text", options={"nullable" : true})
     */
    private $comments;

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
     * Set designerConsultancy
     *
     * @param boolean $designerConsultancy
     * @return InteriorOrder
     */
    public function setDesignerConsultancy($designerConsultancy)
    {
        $this->designerConsultancy = $designerConsultancy;

        return $this;
    }

    /**
     * Get designerConsultancy
     *
     * @return boolean 
     */
    public function getDesignerConsultancy()
    {
        return $this->designerConsultancy;
    }

    /**
     * Set mediaEquipIntegration
     *
     * @param boolean $mediaEquipIntegration
     * @return InteriorOrder
     */
    public function setMediaEquipIntegration($mediaEquipIntegration)
    {
        $this->mediaEquipIntegration = $mediaEquipIntegration;

        return $this;
    }

    /**
     * Get mediaEquipIntegration
     *
     * @return boolean 
     */
    public function getMediaEquipIntegration()
    {
        return $this->mediaEquipIntegration;
    }

    /**
     * Set lightDesigns
     *
     * @param boolean $lightDesigns
     * @return InteriorOrder
     */
    public function setLightDesigns($lightDesigns)
    {
        $this->lightDesigns = $lightDesigns;

        return $this;
    }

    /**
     * Get lightDesigns
     *
     * @return boolean 
     */
    public function getLightDesigns()
    {
        return $this->lightDesigns;
    }

    /**
     * Set floorMaterial
     *
     * @param string $floorMaterial
     * @return InteriorOrder
     */
    public function setFloorMaterial($floorMaterial)
    {
        $this->floorMaterial = $floorMaterial;

        return $this;
    }

    /**
     * Get floorMaterial
     *
     * @return string 
     */
    public function getFloorMaterial()
    {
        return $this->floorMaterial;
    }

    /**
     * Set ceilingMaterial
     *
     * @param string $ceilingMaterial
     * @return InteriorOrder
     */
    public function setCeilingMaterial($ceilingMaterial)
    {
        $this->ceilingMaterial = $ceilingMaterial;

        return $this;
    }

    /**
     * Get ceilingMaterial
     *
     * @return string 
     */
    public function getCeilingMaterial()
    {
        return $this->ceilingMaterial;
    }

    /**
     * Set wallsMaterial
     *
     * @param string $wallsMaterial
     * @return InteriorOrder
     */
    public function setWallsMaterial($wallsMaterial)
    {
        $this->wallsMaterial = $wallsMaterial;

        return $this;
    }

    /**
     * Get wallsMaterial
     *
     * @return string 
     */
    public function getWallsMaterial()
    {
        return $this->wallsMaterial;
    }

    /**
     * Set furniture
     *
     * @param string $furniture
     * @return InteriorOrder
     */
    public function setFurniture($furniture)
    {
        $this->furniture = $furniture;

        return $this;
    }

    /**
     * Get furniture
     *
     * @return string 
     */
    public function getFurniture()
    {
        return $this->furniture;
    }

    /**
     * Set colorPsychology
     *
     * @param string $colorPsychology
     * @return InteriorOrder
     */
    public function setColorPsychology($colorPsychology)
    {
        $this->colorPsychology = $colorPsychology;

        return $this;
    }

    /**
     * Get colorPsychology
     *
     * @return string 
     */
    public function getColorPsychology()
    {
        return $this->colorPsychology;
    }

    /**
     * Set classicColoristicsCanon
     *
     * @param boolean $classicColoristicsCanon
     * @return InteriorOrder
     */
    public function setClassicColoristicsCanon($classicColoristicsCanon)
    {
        $this->classicColoristicsCanon = $classicColoristicsCanon;

        return $this;
    }

    /**
     * Get classicColoristicsCanon
     *
     * @return boolean 
     */
    public function getClassicColoristicsCanon()
    {
        return $this->classicColoristicsCanon;
    }

    /**
     * Set dominantColor
     *
     * @param string $dominantColor
     * @return InteriorOrder
     */
    public function setDominantColor($dominantColor)
    {
        $this->dominantColor = $dominantColor;

        return $this;
    }

    /**
     * Get dominantColor
     *
     * @return string 
     */
    public function getDominantColor()
    {
        return $this->dominantColor;
    }

    /**
     * Set secondaryColor
     *
     * @param string $secondaryColor
     * @return InteriorOrder
     */
    public function setSecondaryColor($secondaryColor)
    {
        $this->secondaryColor = $secondaryColor;

        return $this;
    }

    /**
     * Get secondaryColor
     *
     * @return string 
     */
    public function getSecondaryColor()
    {
        return $this->secondaryColor;
    }

    /**
     * Set useFengShui
     *
     * @param boolean $useFengShui
     * @return InteriorOrder
     */
    public function setUseFengShui($useFengShui)
    {
        $this->useFengShui = $useFengShui;

        return $this;
    }

    /**
     * Get useFengShui
     *
     * @return boolean 
     */
    public function getUseFengShui()
    {
        return $this->useFengShui;
    }

    /**
     * Set birthDate
     *
     * @param \DateTime $birthDate
     * @return InteriorOrder
     */
    public function setBirthDate($birthDate)
    {
        $this->birthDate = $birthDate;

        return $this;
    }

    /**
     * Get birthDate
     *
     * @return \DateTime 
     */
    public function getBirthDate()
    {
        return $this->birthDate;
    }

    /**
     * Set useFengShuiForPartner
     *
     * @param \DateTime $useFengShuiForPartner
     * @return InteriorOrder
     */
    public function setUseFengShuiForPartner($useFengShuiForPartner)
    {
        $this->useFengShuiForPartner = $useFengShuiForPartner;

        return $this;
    }

    /**
     * Get useFengShuiForPartner
     *
     * @return \DateTime 
     */
    public function getUseFengShuiForPartner()
    {
        return $this->useFengShuiForPartner;
    }

    /**
     * Set comments
     *
     * @param string $comments
     * @return InteriorOrder
     */
    public function setComments($comments)
    {
        $this->comments = $comments;

        return $this;
    }

    /**
     * Get comments
     *
     * @return string 
     */
    public function getComments()
    {
        return $this->comments;
    }
}
