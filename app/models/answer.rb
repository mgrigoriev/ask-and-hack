class Answer < ApplicationRecord
  default_scope { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  accepts_nested_attributes_for :attachments

  def make_best
    transaction do
      question.answers.where(best: true).each do |answer|
        answer.update!(best: false)
      end
      update!(best: true)
    end  
  end
end
