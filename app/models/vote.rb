class Vote < ActiveRecord::Base
  belongs_to :votesable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votesable_type, :votesable_id] }
end
