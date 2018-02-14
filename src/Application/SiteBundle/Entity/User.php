<?php

namespace Application\SiteBundle\Entity;

use FOS\UserBundle\Model\User as BaseUser;
use Doctrine\ORM\Mapping as ORM;


/**
 * @ORM\Entity
 * @ORM\Table(name="fos_user")
 */
class User extends BaseUser
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $id;

    /**
     * @ORM\Column(type="string", nullable=true)
     */
    private $urn;

     /**
     * @param string $urn
     * @return $this
     */
    public function setUrn($urn)
    {
        $this->urn = $urn;

        return $this;
    }

    /**
     * @return string
     */
    public function getUrn()
    {
        return $this->urn;
    }
}