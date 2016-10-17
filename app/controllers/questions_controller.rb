class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
    @question = Question.new
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
    @question = Question.create(strong_params)
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
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def strong_params
    params.require(:question).permit(:title, :body)
  end
end
