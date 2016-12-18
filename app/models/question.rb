class Question < ApplicationRecord


  include Votable
  include Commentable
  include Formatted

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, presence: true

  # after_commit :subscribe_owner, on: :create

  scope :daily_questions, lambda { |date|
    all.where(created_at:
                              date.beginning_of_day..date.end_of_day)
  }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def subscribe_owner
    self.subscriptions.create!(user_id: user_id)
  end
end
