module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:vote_plus, :vote_minus, :vote_cancel]
    before_action :set_object, only: [:vote_plus, :vote_minus, :vote_cancel]
  end

  # call to concern methods
  def vote_plus
    success, error = @votesable.add_positive(current_user)

    send_response(success, error)
  end

  def vote_minus
    success, error = @votesable.add_negative(current_user)

    send_response(success, error)
  end

  def vote_cancel
    success, error = @votesable.vote_cancel(current_user)

    send_response(success, error)
  end

  def send_response(success, error)
    if success
      render json: { rating: @votesable.rate, message: t('.message') }.to_json
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
