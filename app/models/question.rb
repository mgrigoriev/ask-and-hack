class Question < ApplicationRecord
  after_create :broadcast

  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :body,  presence: true, length: { minimum: 5 }

  private

    def broadcast
      return if errors.any?

      ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/question',
          locals: { question: self}
        )
      )
    end
end
