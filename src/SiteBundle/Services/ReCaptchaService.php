<?php

namespace SiteBundle\Services;


class ReCaptchaService
{
    const RECAPTCHA_VERIFY_URL = 'https://www.google.com/recaptcha/api/siteverify';

    /**
     * Google ReCaptcha V2 Secret Key
     *
     * @var string
     */
    private $secret;

    public function __construct($secret)
    {
        $this->secret = $secret;
    }

    public function verify($recaptcha)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, self::RECAPTCHA_VERIFY_URL);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, [
            'secret' => $this->secret,
            'response' => $recaptcha
        ]);

        $response = curl_exec($ch);
        curl_close($ch);
        $data = json_decode($response);

        return $data->success;
    }
}