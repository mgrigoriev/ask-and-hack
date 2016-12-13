class Question < ApplicationRecord
  after_create :broadcast
  after_create :subscribe_author

  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

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

  def subscribe_author
    user.subscriptions.create!(question_id: id)
  end
end
