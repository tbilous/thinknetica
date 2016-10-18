class AnswersController < ApplicationController
  before_action :authenticate_user!, except:  [:index]
  before_action :load_answer, only: [:destroy, :edit, :update]
  before_action :load_question, only: [:new, :index, :create ]
  before_action :require_permission, only: :destroy

  def new
    redirect_to_question
  end

  def index
    redirect_to_question
  end
  def edit
    @question = Answer.find(params[:id]).question
  end
  def update
    @question = Answer.find(params[:id]).question
    if @answer.update(strong_params)
      flash[:success] = 'NICE'
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def create
    @answer = @question.answers.new(strong_params.merge(user_id: current_user))
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
    params.require(:answer).permit(:body, :user_id)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def redirect_to_question
    redirect_to question_path(@question)
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' if current_user.id !=
                                                  (Answer.find(params[:id]).user_id ||
                                                      Question.find(@answer.question.user))
  end
end
