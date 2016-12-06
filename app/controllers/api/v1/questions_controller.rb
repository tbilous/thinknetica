class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :load_question, only: :show
  authorize_resource class: Question

  def index
    # respond_with User.where.not(id: current_resource_owner.id)
    # head :ok
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, serializer: SingleQuestionSerializer
  end

  def create
    respond_with(@question = Question.create(strong_params.merge(user: current_resource_owner)))
  end

  protected
  def load_questions
    @questions = Question.all
  end

  def load_question
    @question = Question.find(params['id'])
  end

  def strong_params
    params.require(:question).permit(:title, :body)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
