// ActionCable for questions
App.cable.subscriptions.create('QuestionsChannel', {
  connected: function() {
    return this.perform('follow');
  },
  received: function(data) {
    return $(".questions_list").prepend(data);
  }
});
