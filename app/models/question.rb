class Question < ApplicationRecord
  include Votable
  include Commentable
  include Formatted
  # after_create :subscribe_owner

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, presence: true

  scope :daily_questions, -> { where(created_at:
                                       Date.current.yesterday.beginning_of_day..
                                         Date.current.yesterday.end_of_day) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  private

  def subscribe_owner
    subscriptions.create!(user_id: user_id)
  end
end
