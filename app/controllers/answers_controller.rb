class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question)
    else
      render :new
    end
  end

  private 

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end

end