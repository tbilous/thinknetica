class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
    # if current_user
    #   # @question = current_user.questions.new
    #   @question.attachments.build
    # end
  end

  def show
    # binding.pry
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(strong_params)
    if @question.save
      flash[:success] = 'NICE'
      redirect_to @question
    else
      render :new
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
