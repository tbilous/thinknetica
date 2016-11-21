class AnswersController < ApplicationController
  include Voted
  include Serialized
  include Broadcasted


  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :require_permission, only: [:destroy, :update]

  def update
    @question = @answer.question
    @answer.update(strong_params)

    flash[:success] = 'NICE' if @answer.save
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(strong_params)
    @answer.user = current_user

    if @answer.save
      render_json @answer
    else
      render_errors @answer
    end
  end

  def destroy
    @answer.destroy
  end

  def assign_best
    if current_user.owner_of?(@answer.question)
      @answer.set_best
      flash[:success] = 'NICE'
    else
      flash[:alert] = 'NO RIGHTS!'
    end
  end

  private

  def broadcasted
    publish_broadcast @answer
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
