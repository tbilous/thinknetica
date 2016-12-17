class DailyMailer < ApplicationMailer

  def digest(user)
    @user = user
    @questions = Question.daily_questions(Date.yesterday)
    mail to: user.email if @questions.present?
  end
end
