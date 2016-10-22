function ready() {
  $('.edit-answer-link').click(function(event) {
    event.preventDefault();    
    answer_id = $(this).data('answerId');
    $('.answer-body-' + answer_id).hide();
    $('.answer-controls-' + answer_id).hide();    
    $('form#edit-answer-' + answer_id).show();
  });
}


$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
$(document).on('turbolinks:load', ready);