class Api::V1::QuestionsController < Api::V1::BaseController


  authorize_resource class: User

  def index
    # respond_with User.where.not(id: current_resource_owner.id)
    # head :ok
    @questions = Question.all
    respond_with @questions
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # def current_ability
  #   @ability ||= Ability.new(current_resource_owner)
  # end
end
