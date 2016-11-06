module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:vote_plus, :vote_minus, :vote_cancel]
    before_action :set_object, only: [:vote_plus, :vote_minus, :vote_cancel]
  end

  # call to concern methods
  def vote_plus
    success, error = @votesable.add_plus(current_user)

    callback(success, error)
  end

  def vote_minus
    success, error = @votesable.add_minus(current_user)

    callback(success, error)
  end

  def vote_cancel
    success, error = @votesable.vote_cancel(current_user)

    callback(success, error)
  end

  def callback(success, error)
    if success
      render json: { rating: @votesable.rate }.to_json
    else
      render json: { error: error }.to_json, status: :unprocessable_entity
    end
  end

  private

  # get class by controller`s name
  def model_klass
    controller_name.classify.constantize
  end

  # set target for vote
  def set_object
    @votesable = model_klass.find(params[:id])
  end
end
