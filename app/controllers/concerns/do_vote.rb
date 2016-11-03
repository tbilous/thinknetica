module DoVote
  extend ActiveSupport::Concern

  included do
    # before_action :authenticate_user!
    before_action :set_object, only: [:vote_plus, :vote_minus]
  end

# вьізовьі методов с концерна модели
  def vote_plus
    success, error = @votesable.set_plus(current_user)
    if success
      render json: {rating: @votesable.rate}.to_json
    else
      render json: {error: error}.to_json, status: :unprocessable_entity
    end
  end

  def vote_minus
    binding.pry
    success, error = @votesable.set_minus(current_user)

    if success
      render json: {rating: @votesable.rate}.to_json
    else
      render json: {error: error}.to_json, status: :unprocessable_entity
    end
  end

  private
# определяем вопрос или ответ по имени контроллера
  def model_klass
    controller_name.classify.constantize
  end
# определяем обьект голосования
  def set_object
    @votesable = model_klass.find(params[:id])
  end
end
