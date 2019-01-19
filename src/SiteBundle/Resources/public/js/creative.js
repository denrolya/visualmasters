(function ($) {
    'use strict';

    setTimeout(function() {
        coordinates = {
            about:        $("#about").position().top,
            services:     $("#services").position().top,
            portfolio:    $("#portfolio").position().top,
            media:        $("#media").position().top,
            contact:      $("#contact").position().top,
            descriptions: $("#descriptions").position().top
        };
    }, 500);

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
})(jQuery); // End of use strict
