class DailyMailer < ApplicationMailer
  def digest(user)
    @user = user
    @questions = Question.daily_questions
    mail to: user.email if @questions.present?
  end
end
