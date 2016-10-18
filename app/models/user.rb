class User < ApplicationRecord
  has_many :questions
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(resource)
    if (resource.instance_of? Question) || (resource.instance_of? Answer)
      if resource.user_id == id
        return true
      end
    end
    false
  end

end
