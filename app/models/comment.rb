class Comment < ApplicationRecord

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: 5..128

end
