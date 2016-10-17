class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question
    else
      @question.reload
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user == current_user
      @answer.destroy
      flash[:notice] = 'Answer deleted successfully'
    end
    redirect_to question_path @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
