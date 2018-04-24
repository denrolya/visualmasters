(function($) {
    "use strict";

    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: ($($anchor.attr('href')).offset().top)
        }, 1250, 'easeInOutExpo');
        event.preventDefault();
    });

    $('a.page-scroll.scroll-to-tabs').bind('click', function(event) {
        $('html, body').stop().animate({
            scrollTop: ($("section#descriptions").offset().top)
        }, 1250, 'easeInOutExpo');
    })

    $('body').scrollspy({
        target: '.navbar-fixed-top',
        offset: 51
    })

    $('.navbar-collapse ul li a').click(function() {
        $('.navbar-toggle:visible').click();
    });
})(jQuery); // End of use strict
