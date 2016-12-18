class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :recoverable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable, :confirmable,
         :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :twitter, :github]

  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question

  validates :name, length: 3..20
  validates :email, length: 5..128

  def owner_of?(object)
    id == object.user_id
  end

  # def self.send_daily_digest
  #   find_each.each do |user|
  #     DailyMailer.digest(user).deliver
  #     user.name
  #   end
  # end

  def self.find_for_oauth(auth)
    return nil if auth.blank? || auth.provider.blank? || auth.uid.blank?

    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)

    return authorization.user if authorization

    user = nil
    confirmation_required = false

    if auth.info[:email].present?
      email = auth.info[:email]
      user = User.find_by_email(email)
    else
      email = "#{SecureRandom.hex(8)}@example.org"
      confirmation_required = true
    end

    unless user
      name = if auth[:provider] == 'github'
               auth.info[:nickname]
             else
               auth.info[:name]
             end

      password = Devise.friendly_token[0..20]
      user = User.new(email: email,
                      name: name,
                      password: password,
                      password_confirmation: password)
      # skip send confirmation to fake email
      user.skip_confirmation!
      user.save
    end

    user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    # reinitialize confirmation
    user.update!(confirmed_at: nil) if confirmation_required
    # return user
    user
  end
end
