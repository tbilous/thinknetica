class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_date, :short_title
  has_many :answers

  def short_title
    object.title.truncate(10)
  end
end
