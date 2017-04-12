<?php

namespace Application\LandingBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class BaseOrderType extends AbstractType
{
        /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('name', 'text', ['label' => false, 'attr' => ['placeholder' => 'Your Name *']])
            ->add('email', 'email', ['label' => false, 'attr' => ['placeholder' => 'some@mail.com *']])
            ->add('phonenumber', 'text', ['label' => false, 'attr' => ['placeholder' => 'Phone Number']])
            ->add('address', 'text', ['label' => false, 'attr' => ['placeholder' => 'Address']])
            ->add('postal', 'text', ['label' => false, 'attr' => ['placeholder' => 'Postal Code']])
            ->add('comments', 'textarea', ['label' => false, 'attr' => ['placeholder' => 'Comments *']])
        ;
    }
    
    /**
     * @param OptionsResolverInterface $resolver
     */
    public function setDefaultOptions(OptionsResolverInterface $resolver)
    {
        $resolver->setDefaults(['data_class' => 'Application\LandingBundle\Entity\BaseOrder']);
    }

    /**
     * @return string
     */
    public function getName()
    {
        return 'application_landingbundle_baseorder';
    }
}
