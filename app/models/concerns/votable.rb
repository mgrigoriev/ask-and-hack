module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def vote_up(user)
    if user.author_of?(self)
      error = "You can't vote for your own post"
    elsif has_vote_up_from?(user)
      cancel_vote_from(user)
    else
      cancel_vote_from(user) if has_vote_down_from?(user)
      votes.create(user: user, value: 1)
    end

    error ? [false, error] : true 
  end

  def vote_down(user)
    if user.author_of?(self)
      error = "You can't vote for your own post"
    elsif has_vote_down_from?(user)
      cancel_vote_from(user)
    else
      cancel_vote_from(user) if has_vote_up_from?(user)
      votes.create(user: user, value: -1)
    end

    error ? [false, error] : true 
  end

  def cancel_vote_from(user)
    votes.find_by(user: user).try(:destroy)
  end

  def has_vote_up_from?(user)
    votes.find_by(user: user, value: 1).present?
  end

  def has_vote_down_from?(user)
    votes.find_by(user: user, value: -1).present?
  end
end
