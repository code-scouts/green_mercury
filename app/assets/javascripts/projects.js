$(function() {
  $('form').on('click', '.add_fields', function(event) {
  	event.preventDefault();
    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
  });
});


