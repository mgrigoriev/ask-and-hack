$(document).ajaxError(function (e, xhr, settings) {
  if (xhr.status == 401) {
    $('.answer_errors').html('<div class="alert alert-danger">' + xhr.responseText + '</div>');
  }
});

function ready() {
  $('.edit-question-link').click(function(event) {
    event.preventDefault();    
    question_id = $(this).data('questionId');
    $('.question-title-'    + question_id).hide();
    $('.question-body-'     + question_id).hide();
    $('.question-controls-' + question_id).hide();    
    $('form#edit-question-' + question_id).show();
  });

  $('.edit-answer-link').click(function(event) {
    event.preventDefault();    
    answer_id = $(this).data('answerId');
    $('.answer-body-'     + answer_id).hide();
    $('.answer-controls-' + answer_id).hide();    
    $('form#edit-answer-' + answer_id).show();
  });  
}

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
$(document).on('turbolinks:load', ready);