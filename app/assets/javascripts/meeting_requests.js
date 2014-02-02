$(function() {
  $('.concept-search').click(function() {
    $(this).toggleClass('badge-success');
    if ($('.badge-success').length === 0) {
      $('.request').show();
    } else {
      $('#open-requests').children('.request').hide();
      showRelated(getSelectedConceptNames());
    } 
  });
});

function getSelectedConceptNames() {
  return $('.badge-success').map(function() {
    return $(this).attr('data-name').toLowerCase();
  });
}

function showRelated(tagNames) {
  tagNames.each(function() {
    $('[data-' + this + '="true"]').show();
  });
}
