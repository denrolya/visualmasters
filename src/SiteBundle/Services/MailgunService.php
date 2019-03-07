<?php

namespace SiteBundle\Services;

use Mailgun\Mailgun;

class MailgunService
{
    /** @var Mailgun  */
    private $mailer;

    /** @var string */
    private $domain;

    /** @var string */
    private $from;

    public function __construct($apiKey, $apiUrl, $domain, $from)
    {
        $this->mailer = Mailgun::create($apiKey);
        $this->domain = $domain;
        $this->from = $from;
    }

    public function sendMail($to, $subject, $body)
    {
        $this->mailer->messages()->send($this->domain, [
            'from'    => 'Volodimir Dolya info@visualmasters.co.uk',
            'to'      => $to,
            'subject' => $subject,
            'html'    => $body
        ]);
    }
}