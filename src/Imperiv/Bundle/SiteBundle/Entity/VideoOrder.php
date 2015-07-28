<?php

namespace Imperiv\Bundle\SiteBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * VideoOrder
 * @ORM\Entity
 */
class VideoOrder extends BaseOrder
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     *
     * @ORM\Column(name="max_video_length", type="string", length=255, options={"nullable" : true})
     */
    private $maxVideoLength;

    /**
     * @var string
     *
     * @ORM\Column(name="format", type="string", length=5, options={"nullable" : true})
     */
    private $format;

    /**
     * @var string
     *
     * @ORM\Column(name="music", type="string", length=255, options={"nullable" : true})
     */
    private $music;

    /**
     * @var string
     *
     * @ORM\Column(name="additional_effect", type="string", length=255, options={"nullable" : true})
     */
    private $additionalEffect;

    /**
     * @var string
     *
     * @ORM\Column(name="materials_total_gbs", type="string", length=255, options={"nullable" : true})
     */
    private $materialsTotalGbs;

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
     * Set maxVideoLength
     *
     * @param string $maxVideoLength
     * @return VideoOrder
     */
    public function setMaxVideoLength($maxVideoLength)
    {
        $this->maxVideoLength = $maxVideoLength;

        return $this;
    }

    /**
     * Get maxVideoLength
     *
     * @return string 
     */
    public function getMaxVideoLength()
    {
        return $this->maxVideoLength;
    }

    /**
     * Set format
     *
     * @param string $format
     * @return VideoOrder
     */
    public function setFormat($format)
    {
        $this->format = $format;

        return $this;
    }

    /**
     * Get format
     *
     * @return string 
     */
    public function getFormat()
    {
        return $this->format;
    }

    /**
     * Set music
     *
     * @param string $music
     * @return VideoOrder
     */
    public function setMusic($music)
    {
        $this->music = $music;

        return $this;
    }

    /**
     * Get music
     *
     * @return string 
     */
    public function getMusic()
    {
        return $this->music;
    }

    /**
     * Set additionalEffect
     *
     * @param string $additionalEffect
     * @return VideoOrder
     */
    public function setAdditionalEffect($additionalEffect)
    {
        $this->additionalEffect = $additionalEffect;

        return $this;
    }

    /**
     * Get additionalEffect
     *
     * @return string 
     */
    public function getAdditionalEffect()
    {
        return $this->additionalEffect;
    }

    /**
     * Set materialsTotalGbs
     *
     * @param string $materialsTotalGbs
     * @return VideoOrder
     */
    public function setMaterialsTotalGbs($materialsTotalGbs)
    {
        $this->materialsTotalGbs = $materialsTotalGbs;

        return $this;
    }

    /**
     * Get materialsTotalGbs
     *
     * @return string 
     */
    public function getMaterialsTotalGbs()
    {
        return $this->materialsTotalGbs;
    }
}
