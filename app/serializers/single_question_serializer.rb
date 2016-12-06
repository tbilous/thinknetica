class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_date

  has_many :attachments
  has_many :comments
  has_many :answers
end
