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

  $('.rsvp-container').on('click', '#rsvp-button', function(event) {
    if ($(this).val() == 'RSVP for this event') {
      $(this).val('Cancel RSVP');
    } else {
      $(this).val('RSVP for this event');
    }
  });

});