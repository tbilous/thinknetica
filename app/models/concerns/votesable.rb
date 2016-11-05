module Votesable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votesable, dependent: :destroy
  end

  def rate
    votes.present? ? votes.sum(:challenge) : 0
  end

  def set_plus(user)
    vote(user, 1)
  end

  def set_minus(user)
    vote(user, -1)
  end

  def vote_cancel(user)
    had_voted(user) ? vote_destroy(user) : [true, '']
  end

  def had_voted(user)
    votes.find_by(user: user).present?
  end

  private

  def vote(user, val)
    if user.owner_of?(self)
      error = 'forbidden!'
    else
      vote_destroy(user) if had_voted(user)
      votes.create(user: user, challenge: val)
    end
    send_callback(error)
  end

  def vote_destroy(user)
    if user.owner_of?(self)
      error = 'forbidden!'
    else
      votes.find_by(user: user).try(:destroy)
    end
    send_callback(error)
  end

  def send_callback(error)
    error ? [false, error] : [true, '']
  end

end
