class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 60 }, presence: true
  validates :question_id, presence: true
end
