class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: 5..128
  validates :body, length: { minimum: 60 }
end
