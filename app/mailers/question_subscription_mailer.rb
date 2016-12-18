class QuestionSubscriptionMailer < ApplicationMailer
  def notification_email(user, answer)
    @answer = answer
    @question = answer.question
    @subscription = @question.subscriptions.id
    mail(to: user.email, subject: 'Re: See new answer')
  end
end
