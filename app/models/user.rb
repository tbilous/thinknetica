class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :recoverable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :authorizations

  validates :name, length: 3..20
  validates :email, length: 5..128

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    name = auth.info[:name]
    user = User.find_by_email(email)
    # binding.pry
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0..20]
      user = User.create!(email: email, name: name, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end

  def self.random_password
    Devise.friendly_token[0..20]
  end

  def owner_of?(object)
    id == object.user_id
  end
end
