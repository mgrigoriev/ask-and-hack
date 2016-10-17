class User < ApplicationRecord
  has_many :questions
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(resource)
      resource.user_id == id
  end
end
