function ready() {

  // Edit question
  $('.q_edit_link').click(function(event) {
    event.preventDefault();
    question_id = $(this).data('questionId');
    $('#q-content-' + question_id).hide();
    $('form#q-edit-' + question_id).show();
  });

  // Edit answer
  $('.answers').on('click', '.a_edit_link', function(event) {
    event.preventDefault();
    answer_id = $(this).data('answerId');
    $('#a-content-' + answer_id).hide();
    $('form#a-edit-' + answer_id).show();
  });

  // Add comment (show form on click)
  $('body').on('click', '.c_add_link', function(event) {
    event.preventDefault();
    comment_form = '#comments-'
                    + $(this).data('commentableType') + '-'
                    + $(this).data('commentableId')
                    + ' .new_comment';

    $(comment_form).show();
  });

  // Create answer non-authenticated
  $('#new_answer').on("ajax:error", function(e, xhr, status, error) {
      if (xhr.status == 401) {
        $('.answer_errors').html('<div class="alert alert-danger"> \
          <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>'
            + xhr.responseText + '</div>');
      }
  });  

  // Voting for a question
  $('.q_vote_link').on("ajax:success", function(e, data, status, xhr) {
    question_id = $(this).data('targetId');
    data = $.parseJSON(xhr.responseText);
    $('.vote-error').remove();
    $('#q-rating-' + question_id).html(data.rating);

  }).on("ajax:error", function(e, xhr, status, error) {

    question_id = $(this).data('targetId');

    if (error == 'Forbidden') {
      error_msg = "You can't vote for your own post";
    } else {
      message = $.parseJSON(xhr.responseText);
      error_msg = message.error;
    }

    $('.vote-error').remove();
    alert = '<div class="alert alert-danger vote-error"> \
    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a> ' + error_msg + '</div>';

    $('#q-content-' + question_id).prepend(alert);
  }); 

  // Voting for an answer
  $('.answers').on("ajax:success", '.a_vote_link', function(e, data, status, xhr) {
    answer_id = $(this).data('targetId');
    data = $.parseJSON(xhr.responseText);
    $('.vote-error').remove();
    $('#a-rating-' + answer_id).html(data.rating);

  }).on("ajax:error", '.a_vote_link', function(e, xhr, status, error) {
    answer_id = $(this).data('targetId');

    if (error == 'Forbidden') {
      error_msg = "You can't vote for your own post";
    } else {
      message = $.parseJSON(xhr.responseText);
      error_msg = message.error;
    }

    $('.vote-error').remove();
    alert = '<div class="alert alert-danger vote-error"> \
    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a> ' + error_msg + '</div>';

    $('#a-content-' + answer_id).prepend(alert);
  });
}

$(document).on('ready', ready);
