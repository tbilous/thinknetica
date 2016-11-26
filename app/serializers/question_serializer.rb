class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_date
end
