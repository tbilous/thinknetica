module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votesable, dependent: :destroy
  end

  def rate
    votes.sum(:challenge)
  end

  def add_positive(user)
    vote(user, 1)
  end

  def add_negative(user)
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
    send_response(error)
  end

  def vote_destroy(user)
    if user.owner_of?(self)
      error = 'forbidden!'
    else
      votes.find_by(user: user).try(:destroy)
    end
    send_response(error)
  end

  def send_response(error)
    error ? [false, error] : [true, '']
  end
end
