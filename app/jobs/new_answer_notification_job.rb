class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |user|
      QuestionSubscriptionMailer.notification_email(user, answer).deliver_later
    end
  end
end
