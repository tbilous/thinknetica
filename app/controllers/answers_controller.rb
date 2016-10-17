class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_answer, only: [:destroy]
  before_action :load_question, only: [:new, :index, :create]

  def new
    redirect_question
  end

  def index
    redirect_question
  end

  def create
    @answer = @question.answers.new(strong_params)
    if @answer.save
      flash[:success] = 'NICE'
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
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
    @question = Question.find(params[:question_id])
  end

  def redirect_question
    redirect_to question_path(@question)
  end

  def require_permission
    if current_user != Answer.find(params[:id]).user
      redirect_to root_path
      flash[:alert] = 'NO RIGHTS!'
    end
  end

end
