class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, length: { minimum: 60 }
  validates :question_id, presence: true
end
