class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  before_action :load_questions, only: [:index, :list]

  # Questions with answers
  def index
    respond_with @questions
  end

  # Questions without answers
  def list
    respond_with @questions, each_serializer: QuestionSimpleSerializer
  end

  private

  def load_questions
    @questions = Question.all
  end
end
