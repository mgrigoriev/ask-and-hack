class Answer < ApplicationRecord
  default_scope { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def make_best
    transaction do
      prev_best = question.answers.find_by(best: true)
      prev_best.update!(best: false) if prev_best
      update!(best: true)
    end
  end
end
