class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes

  validates :name, length: 5..128
  validates :email, length: 5..128

  def owner_of?(object)
    id == object.user_id
  end
end
