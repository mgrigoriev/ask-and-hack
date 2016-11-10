// ActionCable for comments
App.cable.subscriptions.create('CommentsChannel', {
  connected: function() {
    if (questionId = $('.answers').data('question-id')) {
      return this.perform('follow', { question_id: questionId });
    } else {
      return this.perform('unfollow');
    }
  },
  received: function(data) {
    comments_selector = '#comments-' + data['commentable_type'] + '-' + data['commentable_id'];

    return $(comments_selector + ' ul').append(JST["templates/comment"]({
      comment:            data['comment'],
      current_user_id:    gon.current_user_id
    }));
  }
});
