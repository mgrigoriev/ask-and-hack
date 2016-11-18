class Comment < ApplicationRecord
  after_create :broadcast

  default_scope { order('created_at') }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }

  private

    def broadcast
      return if errors.any?

      question_id = (commentable_type == 'Question') ? commentable_id : commentable.question_id

      ActionCable.server.broadcast(
        "comments_#{question_id}",
        commentable_id:   commentable_id,
        commentable_type: commentable_type.underscore,
        comment:          self
      )
    end
end
