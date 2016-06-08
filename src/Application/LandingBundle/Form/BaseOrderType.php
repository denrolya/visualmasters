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
            ->add('name', 'text', ['attr' => ['placeholder' => 'Your Name']])
            ->add('email', 'email', ['attr' => ['placeholder' => 'some@mail.com']])
            ->add('phonenumber', 'text', ['attr' => ['placeholder' => 'Phone Number']])
            ->add('address', 'text', ['attr' => ['placeholder' => 'Address']])
            ->add('postal', 'text', ['attr' => ['placeholder' => 'Postal Code']])
            ->add('comments', 'textarea', ['attr' => ['placeholder' => 'Comments']])
        ;
    }
    
    /**
     * @param OptionsResolverInterface $resolver
     */
    public function setDefaultOptions(OptionsResolverInterface $resolver)
    {
        $resolver->setDefaults(array(
            'data_class' => 'Application\LandingBundle\Entity\BaseOrder'
        ));
    }

    /**
     * @return string
     */
    public function getName()
    {
        return 'application_landingbundle_baseorder';
    }
}
