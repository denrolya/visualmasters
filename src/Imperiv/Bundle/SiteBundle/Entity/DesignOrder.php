<?php

namespace Imperiv\Bundle\SiteBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * DesignOrder
 * @ORM\Entity
 */
class DesignOrder extends BaseOrder
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var boolean
     *
     * @ORM\Column(name="use_3d_graphics", type="boolean", options={"nullable" : true})
     */
    private $use3dGraphics;

    /**
     * @var boolean
     *
     * @ORM\Column(name="color_psychology", type="boolean", options={"nullable" : true})
     */
    private $colorPsychology;

    /**
     * @var string
     *
     * @ORM\Column(name="color_preferences", type="string", length=255, options={"nullable" : true})
     */
    private $colorPreferences;

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
     * Set use3dGraphics
     *
     * @param boolean $use3dGraphics
     * @return DesignOrder
     */
    public function setUse3dGraphics($use3dGraphics)
    {
        $this->use3dGraphics = $use3dGraphics;

        return $this;
    }

    /**
     * Get use3dGraphics
     *
     * @return boolean 
     */
    public function getUse3dGraphics()
    {
        return $this->use3dGraphics;
    }

    /**
     * Set colorPsychology
     *
     * @param boolean $colorPsychology
     * @return DesignOrder
     */
    public function setColorPsychology($colorPsychology)
    {
        $this->colorPsychology = $colorPsychology;

        return $this;
    }

    /**
     * Get colorPsychology
     *
     * @return boolean 
     */
    public function getColorPsychology()
    {
        return $this->colorPsychology;
    }

    /**
     * Set colorPreferences
     *
     * @param string $colorPreferences
     * @return DesignOrder
     */
    public function setColorPreferences($colorPreferences)
    {
        $this->colorPreferences = $colorPreferences;

        return $this;
    }

    /**
     * Get colorPreferences
     *
     * @return string 
     */
    public function getColorPreferences()
    {
        return $this->colorPreferences;
    }
}
