class AnswersController < ApplicationController
  before_action :load_answer, only: [:destroy, :edit]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(strong_params)
    flash[:success] = 'NICE!' if @answer.save
    redirect_to question_path(@question)
  end

  def destroy
    @answer.destroy
    render 'questions/show', success: 'Nice'
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
