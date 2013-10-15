$(function() {

  $('body').on('click', '#show-history-button', function() {
    $('#toggle-history-button').empty().append(' <button class="toggle-history-button" id="hide-history-button">Hide</button>');
    $('#description-history-table').show();
    return false;
  });

  $('body').on('click', '#hide-history-button', function() {
    $('#toggle-history-button').empty().append(' <button class="toggle-history-button" id="show-history-button">Show</button>');
    $('#description-history-table').hide();
    return false;
  });

  return false;
});