class Question < ApplicationRecord
  include Votable
  include Commentable
  include Formatted

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :title, :body, presence: true

  scope :daily_questions, lambda { |date| self.where(created_at:
                                                       date.beginning_of_day..date.end_of_day) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
