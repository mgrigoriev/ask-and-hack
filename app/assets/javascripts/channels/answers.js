// ActionCable for answers
App.cable.subscriptions.create('AnswersChannel', {
  connected: function() {
    if (questionId = $('.answers').data('question-id')) {
      return this.perform('follow', { question_id: questionId });
    } else {
      return this.perform('unfollow');
    }
  },
  received: function(data) {
    return $(".answers").append(JST["templates/answer"]({
      answer:             data['answer'],
      answer_attachments: data['answer_attachments'],
      answer_rating:      data['answer_rating'],
      current_user_id:    gon.current_user_id,
      question_user_id:   data['question_user_id']
    }));

  }
});
