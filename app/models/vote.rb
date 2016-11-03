class Vote < ActiveRecord::Base
  belongs_to :votesable, polymorphic: true
  belongs_to :user
  has_many :votes, as: :votesable, dependent: :destroy

  validates :user_id, uniqueness: { scope: [:votesable_type, :votesable_id] }

end
