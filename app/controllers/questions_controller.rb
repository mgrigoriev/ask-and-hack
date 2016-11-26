class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :set_gon_current_user, only: :show

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.order('created_at desc'))
  end

  def show
    respond_with(@question, @answer)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def set_gon_current_user
    gon.current_user_id = current_user ? current_user.id : 0
  end
end
