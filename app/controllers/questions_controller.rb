class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy, :vote_up, :vote_down]

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

  def vote_up
    success, error = @question.vote_up(current_user)

    respond_to do |format|
      if success
        format.json { render json: {rating: @question.votes.sum(:value)}.to_json }
      else
        format.json { render json: {error: error}.to_json, status: :unprocessable_entity }
      end
    end
  end

  def vote_down
    success, error = @question.vote_down(current_user)

    respond_to do |format|
      if success
        format.json { render json: {rating: @question.votes.sum(:value)}.to_json }
      else
        format.json { render json: {error: error}.to_json, status: :unprocessable_entity }
      end
    end
  end  

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
