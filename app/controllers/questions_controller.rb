class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
    @question = current_user.questions.new if current_user
  end

  def show
    @answers = @question.answers.all
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(strong_params)
    if @question.save
      flash[:success] = 'NICE'
      redirect_to @question
    else
      render :index
    end
  end

  def update
    if @question.update(strong_params)
      redirect_to @question, success: 'Nice'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:success] = 'NICE!'
    redirect_to root_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def strong_params
    params.require(:question).permit(:title, :body)
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' unless current_user && current_user.owner_of?(@question)
  end
end
