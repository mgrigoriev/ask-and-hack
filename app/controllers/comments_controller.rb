class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    klass = [Question, Answer].detect{|c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def publish_comment
    return if @comment.errors.any?
    
    question_id = (@comment.commentable_type == 'Question') ? @comment.commentable_id : @comment.commentable.question_id

    ActionCable.server.broadcast(
      "comments_#{question_id}",
      commentable_id:   @comment.commentable_id,
      commentable_type: @comment.commentable_type.underscore,
      comment:          @comment
    )
  end
end
