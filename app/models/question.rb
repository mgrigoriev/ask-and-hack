class Question < ApplicationRecord
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy
  
  # votable
  has_many :votes, as: :votable

  validates :title, presence: true, length: { minimum: 10 }
  validates :body,  presence: true, length: { minimum: 10 }

  # votable
  def has_vote_up_from?(user)
    votes.find_by(user: user, value: 1).present?
  end

  def has_vote_down_from?(user)
    votes.find_by(user: user, value: -1).present?
  end

  def cancel_vote_from(user)
    votes.find_by(user: user).try(:destroy)
  end

  def vote_up(user)
    if user.author_of?(self)
      error = "You can't vote for your own post"
    elsif has_vote_up_from?(user)
      error = "You can't vote up the post twice"
    else
      cancel_vote_from(user) if has_vote_down_from?(user)
      votes.create(user: user, value: 1)
    end
  end

  def vote_down(user)
    if user.author_of?(self)
      error = "You can't vote for your own post"
    elsif has_vote_down_from?(user)
      error = "You can't vote up the post twice"
    else
      cancel_vote_from(user) if has_vote_up_from?(user)
      votes.create(user: user, value: -1)
    end
  end
end