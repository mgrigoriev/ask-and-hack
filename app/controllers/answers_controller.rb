class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :make_best]
  before_action :load_question, only: :create

  respond_to :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def make_best
    @answer.make_best
    respond_with(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
