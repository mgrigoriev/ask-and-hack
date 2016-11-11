class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :make_best]
  after_action :publish_answer, only: [:create]
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def make_best
    if current_user.author_of?(@answer.question)
      @answer.make_best
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    files = []
    @answer.attachments.each { |a| files << { id: a.id, file_url: a.file.url, file_name: a.file.identifier } }

    ActionCable.server.broadcast(
      "answers_#{params[:question_id]}",
      answer:             @answer,
      answer_attachments: files,
      answer_rating:      @answer.rating,
      question_user_id:   @answer.question.user_id
    )
  end
end
