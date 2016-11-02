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
    votes.find_by(user: user, value: 1).present?
  end

  def has_vote_down_from?(user)
    votes.find_by(user: user, value: -1).present?
  end

  private

  def vote(user, val)
    if user.author_of?(self)
      error = "You can't vote for your own post"
    else
      need_create = (has_vote_down_from?(user) && val == -1) || (has_vote_up_from?(user) && val == 1) ? false : true
      cancel_vote_from(user) 
      votes.create(user: user, value: val) if need_create
    end

    error ? [false, error] : [true, '']
  end
end
