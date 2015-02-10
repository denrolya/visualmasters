$(document).ready(function() {
    $(".transp-zone-hide").on('click', function(event) {
        transpZone = $(this).parent().parent();
        transpZoneContent = transpZone.children(".transp-zone-content");
        transpZoneControls = $(this).parent();
        console.log(transpZoneContent);
        transpZoneControls.children(".transp-zone-hide").toggleClass("invisible");
        transpZone.animate( { height:"20px" }, { queue:false, duration:500 , complete: function() {
            transpZoneControls.children(".transp-zone-reveal").toggleClass("invisible");
            transpZoneContent.toggleClass("invisible");
        }});
    });
    
    $(".transp-zone-reveal").on('click', function(event) {
        transpZone = $(this).parent().parent();
        transpZoneContent = transpZone.children(".transp-zone-content");
        transpZoneControls = $(this).parent();
        console.log(transpZoneContent);
        transpZoneControls.children(".transp-zone-reveal").toggleClass("invisible");
        transpZone.animate( { height:"100%" }, { queue:false, duration:500 , complete: function() {
            transpZoneControls.children(".transp-zone-hide").toggleClass("invisible");
            transpZoneContent.toggleClass("invisible");
        }});
    });
});