class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  before_action :load_questions, only: [:index, :list]
  before_action :load_question, only: :show

  def index
    respond_with @questions
  end

  def list
    respond_with @questions, each_serializer: QuestionSimpleSerializer
  end

  def show
    respond_with @question, serializer: QuestionComplexSerializer
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_resource_owner)))
  end

  private

  def load_questions
    @questions = Question.all
  end

  def load_question
    @question = Question.find(params['id'])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
