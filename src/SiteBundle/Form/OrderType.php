<?php

namespace SiteBundle\Form;

use SiteBundle\Entity\Order;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class OrderType extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('name', TextType::class, [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Your Name *'
                ]
            ])
            ->add('email', EmailType::class, [
                'label' => false,
                'attr' => [
                    'placeholder' => 'some@mail.com *'
                ]
            ])
            ->add('phonenumber', TextType::class, [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Phone Number'
                ]
            ])
            ->add('address', TextType::class, [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Address'
                ]
            ])
            ->add('postal', TextType::class, [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Postal Code'
                ]
            ])
            ->add('comments', TextareaType::class, [
                'label' => false,
                'attr' => [
                    'placeholder' => 'Comments'
                ]
            ]);
    }

    /**
     * @param OptionsResolver $resolver
     */
    public function setDefaultOptions(OptionsResolver $resolver)
    {
        $resolver
            ->setDefaults([
                'data_class' => Order::class
            ]);
    }

    /**
     * @return string
     */
    public function getName()
    {
        return 'order';
    }
}
