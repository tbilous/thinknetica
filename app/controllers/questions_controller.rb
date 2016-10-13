class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
  end

  def create
  end

  def view
  end

  def destroy
  end

  def edit
  end
end
