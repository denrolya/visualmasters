(function(a){a("a.page-scroll").bind("click",function(c){var b=a(this);a("html, body").stop().animate({scrollTop:(a(b.attr("href")).offset().top)},1250,"easeInOutExpo");c.preventDefault()});a("a.page-scroll.scroll-to-tabs").bind("click",function(b){a("html, body").stop().animate({scrollTop:(a("section#descriptions").offset().top)},1250,"easeInOutExpo")});a("body").scrollspy({target:".navbar-fixed-top",offset:51});a(".navbar-collapse ul li a").click(function(){a(".navbar-toggle:visible").click()})})(jQuery);