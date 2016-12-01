class AnswersController < ApplicationController
  include Voted
  include Serialized
  include Broadcasted

  before_action :verify_requested_format!
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :load_question, only: [:update]

  respond_to :js, :json

  authorize_resource

  def update
    @answer.update(strong_params)
    respond_with(@answer)
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(strong_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def assign_best
    respond_with(@answer.set_best)
  end

  private

  def broadcasted
    publish_broadcast @answer
  end

  def strong_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Answer.find(params[:id]).question
  end
end
