class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:notice] = "Question added successfully"
      redirect_to @question
    else
      @question.attachments.build if !@question.attachments.present?
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end  

  def destroy
    if current_user.author_of?(@question)
      flash[:notice] = "Question deleted successfully"
      @question.destroy
    end
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
