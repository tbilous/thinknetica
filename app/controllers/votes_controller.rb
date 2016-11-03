class VotesController < ApplicationController

  # before_action :authenticate_user!
  # before_action :votes_right
  # before_action :load_question
  #
  #
  # def vote_positive
  #
  #   binding.pry
  #   if @question.votes.where(user: current_user).present?
  #     @question.votes.update_all(challenge: 1)
  #   else
  #     @question.votes.create(usern : current_user, challenge: 1)
  #   end
  # end
  #
  # def vote_negative
  #   @question = Question.find(params[:id])
  #   if @question.votes.where(user: current_user).present?
  #     @vote = @question.votes.update_all(challenge: -1)
  #   else
  #     @vote = @question.votes.create(user: current_user, challenge: -1)
  #   end
  # end
  #
  #
  # private
  # def load_question
  #   @question = Question.find(params[:id])
  # end
  #
  # def votes_right
  #   flash[:alert] = 'No rights!' if current_user && current_user.owner_of?(@question)
  # end
end
