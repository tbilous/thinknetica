class Vote < ActiveRecord::Base
  belongs_to :votesable, polymorphic: true
  belongs_to :user
  has_many :votes, as: :votesable, dependent: :destroy
end
