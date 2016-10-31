class AnswersController < ApplicationController
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

    flash[:success] = 'NICE!' if @answer.save

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

  private

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
