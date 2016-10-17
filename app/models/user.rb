class User < ApplicationRecord
  has_many :questions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
