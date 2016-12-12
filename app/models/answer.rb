class Answer < ApplicationRecord
  after_create_commit :broadcast
  after_create :notify_subscribers

  include Attachable
  include Votable
  include Commentable

  default_scope { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def make_best
    transaction do
      question.answers.where(best: true).each do |answer|
        answer.update!(best: false)
      end
      update!(best: true)
    end
  end

  private

  def broadcast
    return if errors.any?

    files = []
    attachments.each { |a| files << { id: a.id, file_url: a.file.url, file_name: a.file.identifier } }

    ActionCable.server.broadcast(
      "answers_#{question_id}",
      answer:             self,
      answer_attachments: files,
      answer_rating:      rating,
      question_user_id:   question.user_id
    )
  end

  def notify_subscribers
    NewAnswerNotificationJob.perform_later self
  end
end
