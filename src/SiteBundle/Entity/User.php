<?php

namespace SiteBundle\Entity;

use FOS\UserBundle\Model\User as BaseUser;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="user")
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
     * @var string
     *
     * @ORM\Column(name="crn", type="string", length=255, nullable=true)
     */
    private $crn;

    public function setCrn($crn)
    {
        $this->crn = $crn;

        return $this;
    }

    public function getCrn()
    {
        return $this->crn;
    }
}