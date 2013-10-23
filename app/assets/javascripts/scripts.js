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

  $('.ckeditor').ckeditor({
    
  });
});

