class Vote < ActiveRecord::Base
  belongs_to :votesable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: {scope: [:votesable_type, :votesable_id]}
  # def rating
  #   votes.sum(:challenge)
  # end
  #
  def vote_set_positive(user)
    vote(user, 1)
  end

  #
  # def vote_set_negative(user)
  #   vote(user, -1)
  # end
  #
  def has_vote?(user)
    where(user: user).present?
  end

  def votes(user)
    id == id.where(user: user)
  end

  #
  # def has_vote_negative?(user)
  #   where(user: user, challenge: -1).present?
  # end

  def vote(user, val)
    if user.owner_of?(self)
      error = "You can't vote for your own post"
    else
      if has_vote?(user)
        Vote.update(challenge: val)
      else
        Vote.create(user: user, challenge: val)
      end
      cancel_vote_from(user)
    end
      error ? [false, error] : [true, '']
  end
end
