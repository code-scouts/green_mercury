$(function() {

  $('#toggle-history-container').on('click', '.toggle-history-button', function(event) {
    event.preventDefault();
    $('#description-history-table').toggle();
    if ($(this).text() == 'Hide') {
      $(this).text('Show');
    } else {
      $(this).text('Hide');
    }
  });

  $('.wysihtml5').each(function(i, elem) {
    $(elem).wysihtml5();
  });
  
  $('#toggle-map-container').on('click', '#toggle-map-button', function(event) {
    event.preventDefault();
    $('#location-map').toggle();
    if ($(this).text() == 'Hide map') {
      $(this).text('Show map');
    } else {
      $(this).text('Hide map');
    }
  });

});

