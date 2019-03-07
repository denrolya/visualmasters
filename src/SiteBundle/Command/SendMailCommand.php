<?php

namespace SiteBundle\Command;

use Doctrine\ORM\EntityManagerInterface;
use SiteBundle\Entity\Order;
use SiteBundle\Services\MailgunService;
use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class SendMailCommand extends ContainerAwareCommand
{
    protected function configure()
    {
        $this
            ->setName('send:mail')
            ->setDescription('send:mail')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $mailgun = $this->getContainer()->get('app.mailgun_service');
        $em = $this->getContainer()->get('doctrine.orm.entity_manager');
        $templating = $this->getContainer()->get('templating');

        $order = $em->getRepository(Order::class)->findOneBy(['id' => 134]);

        $mailgun
            ->sendMail(
                $order->getEmail(),
                '[NEW] Order was successfully submitted!',
                'Your order to VisualMasters was successfully created.'
            );

        $mailgun
            ->sendMail(
                'info@visualmasters.co.uk',
                '[NEW] Order was successfully created!',
                $templating->render(
                    '::order_success.email.html.twig',
                    ['order' => $order]
                )
            );
        $output->writeln('Command result.');
    }

}
