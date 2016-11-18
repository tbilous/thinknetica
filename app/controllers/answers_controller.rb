class AnswersController < ApplicationController
  include Voted
  include Serialized

  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :require_permission, only: [:destroy, :update]

  after_action :publish_answer, only: :create

  def update
    @question = @answer.question
    @answer.update(strong_params)

    flash[:success] = 'NICE' if @answer.save
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(strong_params)
    @answer.user = current_user

    # flash[:success] = 'NICE!' if @answer.save
    if @answer.save
      render_json @answer
      # render json: @answer, root: 'answer', meta_key: :message, meta: t('.message')
    else
      render_errors_for @answer
    end
    # if @answer.save
    #   # render json: @answer
    # else
    #   render json: @answer.errors.full_messages, status: :unprocessable_entity
    # end
  end

  def destroy
    @answer.destroy
    flash[:success] = 'NICE'
  end

  def assign_best
    if current_user.owner_of?(@answer.question)
      @answer.set_best
      flash[:success] = 'NICE'
    else
      flash[:alert] = 'NO RIGHTS!'
    end
  end
  def render_errors_for(resource)
    flash.now.alert = resource.errors.full_messages.join(', ')
  end
  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast "answers_#{@answer.question_id}", answer: @answer, meta_key: :message, meta: t('.message')
  end

  def set_gon_current_user
    gon.current_user_id = current_user ? current_user.id : 0
  end

  def strong_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Answer.find(params[:id]).question
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' unless current_user && current_user.owner_of?(@answer)
  end
end
