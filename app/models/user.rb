class User < ApplicationRecord
  before_create :skip_confirmation!

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def author_of?(resource)
    resource.user_id == id
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def last_authorization_twitter?
    (authorizations.any? && authorizations.last.provider == 'twitter') ? true : false
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if auth.info[:email].present?
      email = auth.info[:email]
      user = User.where(email: email).first
    else
      email = random_email
      confirmation_required = true
    end

    if !user
      password = random_password
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.update!(confirmed_at: nil) if confirmation_required
    end

    user.create_authorization(auth)
    user
  end

  def self.random_password
    Devise.friendly_token[0..20]
  end

  def self.random_email
    "#{SecureRandom.hex(15)}@example.org"
  end
end
