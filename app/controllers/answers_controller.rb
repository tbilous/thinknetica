class AnswersController < ApplicationController
  before_action :load_answer, only: [:destroy, :edit]

  def create
    @question = Question.find(params[:question_id])
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

  def edit
  end

  private

  def strong_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
