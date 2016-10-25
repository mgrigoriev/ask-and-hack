class Answer < ApplicationRecord
  default_scope { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def make_best
    question.answers.where(best: true).update_all(best: false)
    update(best: true)
  end
end
