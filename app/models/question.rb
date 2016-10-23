class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true, length: 5..128
  validates :body, length: { minimum: 60 }
end
