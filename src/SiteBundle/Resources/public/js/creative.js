(function($) {
    "use strict";

    // TODO: Fix scrolling to divs here
    $('.page-scroll').on('click', function(event) {
        event.preventDefault();
        var position = coordinates[$(this).attr('href').substr(1)];

        $('html, body').stop().animate({
            scrollTop: position - 70
        }, 500, 'linear');
    });

    // TODO: Fix scrolling to divs here
    $('.page-scroll.scroll-to-tabs').on('click', function(event) {
        event.preventDefault();

        $('html, body').stop().animate({
            scrollTop: coordinates.descriptions
        }, 1000, 'easeInOutExpo');
    })

    $('body').scrollspy({
        target: '.navbar-fixed-top',
        offset: 51
    })

    $('.navbar-collapse ul li a').click(function() {
        $('.navbar-toggle:visible').click();
    });
})(jQuery); // End of use strict
