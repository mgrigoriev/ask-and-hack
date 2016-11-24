module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def rating
    votes.sum(:value)
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  def cancel_vote_from(user)
    votes.find_by(user: user).try(:destroy)
  end

  def has_vote_up_from?(user)
    has_vote_from?(user, 1)
  end

  def has_vote_down_from?(user)
    has_vote_from?(user, -1)
  end

  private

  def has_vote_from?(user, val)
    votes.exists?(user: user, value: val)
  end

  def vote(user, val)
    need_create = has_vote_from?(user, val) ? false : true
    cancel_vote_from(user)
    votes.create(user: user, value: val) if need_create
  end
end
