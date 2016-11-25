class AnswersController < ApplicationController

  include Voted
  include Serialized
  include Broadcasted
  respond_to :js, :json

  before_action :verify_requested_format!
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :require_permission, only: [:destroy, :update]
  before_action :load_question, only: [:update]
  before_action :check_question_authority, only: [:assign_best]

  def update
    @answer.update(strong_params)
    respond_with(@answer)
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(strong_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def assign_best
    respond_with(@answer.set_best)
  end

  private

  def broadcasted
    publish_broadcast @answer
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

  def check_question_authority
    flash[:alert] = 'NO RIGHTS!' unless current_user.owner_of?(@answer.question)
  end
end
