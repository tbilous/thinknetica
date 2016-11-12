module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end


  private

  def add_comment(user, content)
    if user.owner_of?(self)
      error = 'forbidden!'
    else
      comments.create(user: user, body: content)
    end
    send_response(error)
  end

  def vote_destroy(user)
    if user.owner_of?(self)
      error = 'forbidden!'
    else
      comments.find_by(user: user).try(:destroy)
    end
    send_response(error)
  end

  def send_response(error)
    error ? [false, error] : [true, '']
  end
end
