<?php

namespace Application\SiteBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 */
class InteriorOrder extends BaseOrder
{
    /**
     * @var string
     *
     * @ORM\Column(name="subcategory", type="string", length=255, options={"nullable" : false})
     */
    private $subcategory;

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
     * @ORM\Column(name="light_design", type="boolean", options={"nullable" : true})
     */
    private $lightDesign;

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
     * @ORM\Column(name="use_feng_shui_for_partner", type="boolean", options={"nullable" : true})
     */
    private $useFengShuiForPartner;

    /**
     * @ORM\Column(name="style_example", type="string", length=255, options={"nullable" : true})
     */
    private $styleExample;

    /**
     * @ORM\Column(name="drawing", type="string", length=255, options={"nullable" : true})
     */
    private $drawing;

    /**
     * @ORM\Column(name="environment_photo", type="string", length=255, options={"nullable" : true})
     */
    private $environmentPhoto;

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
     * Set lightDesign
     *
     * @param boolean $lightDesign
     * @return InteriorOrder
     */
    public function setLightDesign($lightDesign)
    {
        $this->lightDesign = $lightDesign;

        return $this;
    }

    /**
     * Get lightDesign
     *
     * @return boolean 
     */
    public function getLightDesign()
    {
        return $this->lightDesign;
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
     * Set subcategory
     *
     * @param string $subcategory
     * @return InteriorOrder
     */
    public function setSubcategory($subcategory)
    {
        $this->subcategory = $subcategory;

        return $this;
    }

    /**
     * Get subcategory
     *
     * @return string 
     */
    public function getSubcategory()
    {
        return $this->subcategory;
    }

    /**
     * Set styleExample
     *
     * @param string $styleExample
     * @return InteriorOrder
     */
    public function setStyleExample($styleExample)
    {
        $this->styleExample = $styleExample;

        return $this;
    }

    /**
     * Get styleExample
     *
     * @return string
     */
    public function getStyleExample()
    {
        return $this->styleExample;
    }

    /**
     * Set drawing
     *
     * @param string $drawing
     * @return InteriorOrder
     */
    public function setDrawing($drawing)
    {
        $this->drawing = $drawing;

        return $this;
    }

    /**
     * Get drawing
     *
     * @return string
     */
    public function getDrawing()
    {
        return $this->drawing;
    }

    /**
     * Set environmentPhoto
     *
     * @param string $environmentPhoto
     * @return InteriorOrder
     */
    public function setEnvironmentPhoto($environmentPhoto)
    {
        $this->environmentPhoto = $environmentPhoto;

        return $this;
    }

    /**
     * Get environmentPhoto
     *
     * @return string
     */
    public function getEnvironmentPhoto()
    {
        return $this->environmentPhoto;
    }
}
