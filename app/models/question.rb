class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  validates :title, presence: true, length: { minimum: 10 }
  validates :body,  presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments
end
