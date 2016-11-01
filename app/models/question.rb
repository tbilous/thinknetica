class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :title, :body, presence: true, length: 5..128
  validates :body, length: { minimum: 60 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
