class Comment < ApplicationRecord
  default_scope { order('created_at') }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validates :body, length: { minimum: 5 }
end
