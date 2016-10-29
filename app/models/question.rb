class Question < ApplicationRecord
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable

  validates :title, presence: true, length: { minimum: 10 }
  validates :body,  presence: true, length: { minimum: 10 }
end
