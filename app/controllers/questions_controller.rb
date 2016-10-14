class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.create(strong_params)
    if @question.save
      flash[:success] = 'NICE!'
      redirect_to question_path(@question)
    else
      render 'new'
    end
  end

  def update
    if @question.update_attributes(strong_params)
      flash[:success] = 'NICE!'
      redirect_to @question
    else
      render 'edit'
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
