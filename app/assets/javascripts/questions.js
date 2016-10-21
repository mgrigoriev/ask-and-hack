$(document).ajaxError(function (e, xhr, settings) {
  if (xhr.status == 401) {
    $('.answer_errors').html('<div class="alert alert-danger">' + xhr.responseText + '</div>');
  }
});