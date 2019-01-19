(function ($) {

    $(document).ready(function () {
        'use strict';

        var coordinates = {
            about:        $("#about").offset().top,
            services:     $("#services").offset().top,
            portfolio:    $("#portfolio").offset().top,
            media:        $("#media").offset().top,
            contact:      $("#contact").offset().top,
            descriptions: $("#descriptions").offset().top
        };

        $('.page-scroll').on('click', function (event) {
            event.preventDefault();
            var position = coordinates[$(this).attr('href').substr(1)];

            $('html, body').stop().animate({
                scrollTop: position - 70
            }, 500, 'linear');
        });

        $('.page-scroll.scroll-to-tabs').on('click', function (event) {
            event.preventDefault();

            $('html, body').stop().animate({
                scrollTop: coordinates.descriptions
            }, 1000, 'easeInOutExpo');
        });

        $('body').scrollspy({
            target: '.navbar-fixed-top',
            offset: 51
        });

        $('.navbar-collapse ul li a').click(function () {
            $('.navbar-toggle:visible').click();
        });
    });

}(jQuery));
