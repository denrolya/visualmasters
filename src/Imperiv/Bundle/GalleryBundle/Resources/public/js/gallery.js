var playSpan = "<span class=\"glyphicon glyphicon-play\"></span>",
    pauseSpan = "<span class=\"glyphicon glyphicon-pause\"></span>";
    
$(document).ready(function() {
    maximageCycleOptions = {
        fx: 'fade',
        speed: 4000,
        timeout: slidesTimeout*10000,
        prev: '#arrow_left',
        next: '#arrow_right',
    };

    if (!onIndexPage) {
        maximageCycleOptions.pager = '#nav_slideshow ul';
        maximageCycleOptions.pagerAnchorBuilder = function(idx, slide) {
            var imgsrc = jQuery.Slides[idx].url.replace("big", "small");
            return '<li><a href="#" rel="nofollow"><img src=' + imgsrc + ' /></a></li>';
        };
    }

    $('#maximage').maximage({
        cycleOptions: maximageCycleOptions,
//        cssTransitions: false,
        onFirstImageLoaded: function(){
            $('#maximage').fadeIn('fast');
        }
    });
        
    $(".transp-zone-vertical .transp-zone-hide").on('click', function(event) {
        transpZone = $(this).parent().parent();
        transpZoneContent = transpZone.children(".transp-zone-content");
        transpZoneControls = $(this).parent();
        transpZoneControls.children(".transp-zone-hide").toggleClass("invisible");
        transpZoneContent.toggleClass("invisible");
        transpZone.animate( { height:"20px" }, { queue:false, duration:500 , complete: function() {
            transpZoneControls.children(".transp-zone-reveal").toggleClass("invisible");
        }});

    });
    
    $(".transp-zone-vertical .transp-zone-reveal").on('click', function(event) {
        transpZone = $(this).parent().parent();
        transpZoneContent = transpZone.children(".transp-zone-content");
        transpZoneControls = $(this).parent();
        transpZoneControls.children(".transp-zone-reveal").toggleClass("invisible");
        transpZone.animate( { height:"100%" }, { queue:false, duration:500 , complete: function() {
            transpZoneControls.children(".transp-zone-hide").toggleClass("invisible");
            transpZoneContent.toggleClass("invisible");
        }});
    });
    
    $(".transp-zone-horizontal .transp-zone-hide").on('click', function(event) {
        transpZone = $(this).parent().parent();
        transpZoneContent = transpZone.children(".transp-zone-content");
        transpZoneControls = $(this).parent();
        transpZoneControls.children(".transp-zone-hide").toggleClass("invisible");
        transpZoneContent.toggleClass("invisible");
        transpZone.animate( { height:"20px" }, { queue:false, duration:500 , complete: function() {
            transpZoneControls.children(".transp-zone-reveal").toggleClass("invisible");
        }});
        transpZone.animate({ top: "3px" }, 500);
    });
    
    $(".transp-zone-horizontal .transp-zone-reveal").on('click', function(event) {
        transpZone = $(this).parent().parent();
        transpZoneContent = transpZone.children(".transp-zone-content");
        transpZoneControls = $(this).parent();
        transpZonePosition = transpZone.attr('data-position');
        transpZoneSize = transpZone.attr('data-size');
        
        transpZoneControls.children(".transp-zone-reveal").toggleClass("invisible");
        transpZoneContent.toggleClass("invisible");
        transpZone.animate( { height: transpZoneSize + "px" }, { queue:false, duration:500 , complete: function() {
            transpZoneControls.children(".transp-zone-hide").toggleClass("invisible");
        }});
        transpZone.css("display","table");
        transpZone.animate({ top: transpZonePosition + "%" }, 500);
    });
    
    $("#toggle_slideshow").on('click', function(event) {
        $('#maximage').cycle('toggle');
        slideshowTrigger = $(this);
        togglePlay = slideshowTrigger.children(".glyphicon-pause").length == 1;
        slideshowTrigger.empty().append( togglePlay === true ? playSpan : pauseSpan );
    });
    
    // Left/Right/Up/Down arrow keys to navigate
    $(document).keydown(function(event) {
        switch(event.keyCode) {
            case 32:
                $("#toggle_slideshow").click(); event.preventDefault();
                break;
            case 37:
                $('#arrow_left').click(); event.preventDefault();
                break;
            case 38:
                $('.current-slide .transp-zone-hide:not(.invisible)').click(); event.preventDefault();
                break;
            case 39:
                $('#arrow_right').click(); event.preventDefault();
                break;
            case 40:
                $('.current-slide .transp-zone-reveal:not(.invisible)').click(); event.preventDefault();
                break;
        }
    });
});