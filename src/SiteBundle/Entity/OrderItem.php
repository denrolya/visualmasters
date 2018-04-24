<?php

namespace SiteBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * OrderItem
 *
 * @ORM\Table(name="order_item")
 * @ORM\HasLifecycleCallbacks()
 * @ORM\Entity
 */
class OrderItem
{
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var integer
     *
     * @ORM\Column(name="quantity", type="integer")
     */
    private $quantity;

    /**
     * @var string
     *
     * @ORM\Column(name="description", type="string", length=255)
     */
    private $description;

    /**
     * @var string
     *
     * @ORM\Column(name="unitPrice", type="decimal")
     */
    private $unitPrice;

    /**
     * @var integer
     *
     * @ORM\Column(name="officeCharge", type="integer")
     */
    private $officeCharge;

    /**
     * @var string
     *
     * @ORM\Column(name="totalPrice", type="float")
     */
    private $totalPrice;

    /**
     * @ORM\ManyToOne(targetEntity="Order", inversedBy="items")
     * @ORM\JoinColumn(name="order_id", referencedColumnName="id", nullable=false)
     */
    private $order;

    public function __toString()
    {
        return $this->description;
    }

    /**
     * @ORM\PrePersist
     * @ORM\PreUpdate
     */
    public function updateTotalPrice()
    {
        $this->totalPrice =  $this->quantity * $this->unitPrice * (1 + $this->officeCharge/100);
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
     * Set quantity
     *
     * @param integer $quantity
     * @return OrderItem
     */
    public function setQuantity($quantity)
    {
        $this->quantity = $quantity;

        return $this;
    }

    /**
     * Get quantity
     *
     * @return integer 
     */
    public function getQuantity()
    {
        return $this->quantity;
    }

    /**
     * Set description
     *
     * @param string $description
     * @return OrderItem
     */
    public function setDescription($description)
    {
        $this->description = $description;

        return $this;
    }

    /**
     * Get description
     *
     * @return string 
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * Set unitPrice
     *
     * @param string $unitPrice
     * @return OrderItem
     */
    public function setUnitPrice($unitPrice)
    {
        $this->unitPrice = $unitPrice;

        return $this;
    }

    /**
     * Get unitPrice
     *
     * @return string 
     */
    public function getUnitPrice()
    {
        return $this->unitPrice;
    }

    /**
     * Set officeCharge
     *
     * @param integer $officeCharge
     * @return OrderItem
     */
    public function setOfficeCharge($officeCharge)
    {
        $this->officeCharge = $officeCharge;

        return $this;
    }

    /**
     * Get officeCharge
     *
     * @return integer 
     */
    public function getOfficeCharge()
    {
        return $this->officeCharge;
    }

    /**
     * Set totalPrice
     *
     * @param string $totalPrice
     * @return OrderItem
     */
    public function setTotalPrice($totalPrice)
    {
        $this->totalPrice = $totalPrice;

        return $this;
    }

    /**
     * Get totalPrice
     *
     * @return string 
     */
    public function getTotalPrice()
    {
        return $this->totalPrice;
    }

    /**
     * Set product
     *
     * @param Order $order
     * @return OrderItem
     */
    public function setOrder(Order $order = null)
    {
        $this->order = $order;

        return $this;
    }

    /**
     * Get order
     *
     * @return Order
     */
    public function getOrder()
    {
        return $this->order;
    }
}
