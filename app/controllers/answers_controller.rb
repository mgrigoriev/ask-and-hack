class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def make_best
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer.question)
      @answer.make_best
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
