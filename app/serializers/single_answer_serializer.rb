class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_date

  has_many :attachments
  has_many :comments
end
