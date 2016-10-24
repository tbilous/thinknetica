class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_answer, only: [:destroy, :edit, :update]
  before_action :load_question, only: [:index, :edit, :update]
  before_action :require_permission, only: [:destroy, :update]

  # def index
  #   redirect_to @question
  # end
  #
  # def edit
  # end

  def update
    if @answer.update(strong_params)
      flash[:success] = 'NICE'
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
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
    redirect_to :back
  end

  private

  def strong_params
    params.require(:answer).permit(:body)
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
