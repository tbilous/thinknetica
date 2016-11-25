class QuestionsController < ApplicationController
  include Voted
  include Serialized
  include Broadcasted

  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :require_permission, only: [:update, :destroy]
  before_action :load_questions, only: [:index, :create]

  respond_to :json, only: :create
  respond_to :js, only: [:update]
  respond_to :html, only: :destroy

  def index
    @question = Question.new
    @question.attachments.build
  end

  def show
    @question_comment = @question.answers.build
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(strong_params))
    # @question = current_user.questions.create(strong_params)
    #
    # if @question.save
    #   render_json @question
    # else
    #   render_errors @question
    # end
  end

  def update
    # flash[:success] = 'NICE' if @question.update(strong_params)
    respond_with(@question.update(strong_params))
  end

  def destroy
    respond_with(@question.destroy)
    # flash[:success] = 'NICE!'
    # redirect_to root_path
  end

  private

  def broadcasted
    publish_broadcast @question
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def load_questions
    @questions = Question.all
  end

  def strong_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' unless current_user && current_user.owner_of?(@question)
  end
end
