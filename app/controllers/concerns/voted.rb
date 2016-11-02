module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    success, error = @votable.vote_up(current_user)

    if success
      render json: {rating: @votable.rating}.to_json
    else
      render json: {error: error}.to_json, status: :unprocessable_entity
    end
  end

  def vote_down
    success, error = @votable.vote_down(current_user)

    if success
      render json: {rating: @votable.rating}.to_json
    else
      render json: {error: error}.to_json, status: :unprocessable_entity
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
