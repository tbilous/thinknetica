module Votesable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votesable
  end

  def rate
    votes.sum(:challenge)
  end

  def set_plus(user)
    binding.pry
    vote(user, 1)
  end

  def set_minus(user)
    # binding.pry
    vote(user, -1)
  end

  # def cancel_vote_from(user)
  #   votes.find_by(user: user).try(:destroy)
  # end

  # def has_vote_up_from?(user)
  #   votes.find_by(user: user, value: 1).present?
  # end
  #
  # def has_vote_down_from?(user)
  #   votes.find_by(user: user, value: -1).present?
  # end

  def had_voted
    votes.find_by(user: user).present?
  end

  private

  def vote(user, val)
    if !user.owner_of?(self)
      error = 'forbidden!'
    elsif had_voted
      votes.update_all(challenge: val)
    else
      votes.create(user: user, challenge: val)
    end

    error ? [false, error] : [true, '']
  end
end
