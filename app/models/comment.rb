class Comment < ApplicationRecord
  include Formatted

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: 5..128

  default_scope { order('created_at DESC') }

  def root_question_id
    if commentable_type == 'Question'
      commentable_id
    elsif commentable_type == 'Answer'
      commentable.question_id
    end
  end
end
