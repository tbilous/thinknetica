class QuestionsController < ApplicationController
  include Voted
  # include Serialized

  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :require_permission, only: [:update, :destroy]

  def index
    @questions = Question.all
    @question = Question.new
    @question.attachments.build
  end

  def show
    # binding.pry
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
  end

  def edit
  end

  def create
    @question = current_user.questions.create(strong_params)
    if @question.save
      flash[:success] = 'NICE'
      redirect_to @question
    else
      @questions = Question.all
      render :index
    end
  end

  def update
    flash[:success] = 'NICE' if @question.update(strong_params)
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
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' unless current_user && current_user.owner_of?(@question)
  end
end
