(function() {
  'use strict';

  window.addEventListener('load', function() {
    window.cookieconsent.initialise({
      palette:  {
        popup:  {
          background: '#303030',
        },
        button: {
          background: '#fbc02d',
        },
      },
      position: 'bottom-right',
    });
  });

  $('.main-footer a').click(function(e) {
    $('.main-footer a.active').toggleClass('active');

    var prevTabControl = $(e.target).attr('aria-controls');
    $('.main-footer a[aria-controls=\'' + prevTabControl + '\']').toggleClass('active');
    e.preventDefault();
    $(this).tab('show');
  });

  var inputs = $('.inputfile');
  Array.prototype.forEach.call(inputs, function(input) {
    var label = input.nextElementSibling, labelVal = label.innerHTML;

    input.addEventListener('change', function(e) {
      var fileName = e.target.value.split('\\').pop();

      if (fileName) {
        label.querySelector('span').innerHTML = 'Attached...';
      } else {
        label.innerHTML = labelVal;
      }
    });

    // Firefox bug fix
    input.addEventListener('focus', function() { input.classList.add('has-focus'); });
    input.addEventListener('blur', function() { input.classList.remove('has-focus'); });
  });

  $('#orderModal').on('show.bs.modal', function() {
    $('form[name=\'order-form\']')[0].reset();
    $('#order-form').removeClass('hidden');
    $('#order-success-note').addClass('hidden');
  });

  var $loader = $('#loader').hide();
  $(document)
      .ajaxStart(function() {
        $loader.show();
        $('.btn-submit').toggleClass('loader').prop('disabled', true);
        $('.btn-attach').addClass('disabled');
        $('#btn-submit-text').hide();
      })
      .ajaxStop(function() {
        $loader.hide();
        $('.btn-submit').toggleClass('loader').prop('disabled', false);
        $('.btn-attach').removeClass('disabled');
        $('#btn-submit-text').show();
      });
})();
