class QuestionSubscriptionMailer < ApplicationMailer
  def notification_email(user, answer)
    @answer = answer
    @user = user
    @question = answer.question
    mail(to: user.email, subject: 'See new answer')
  end
end
