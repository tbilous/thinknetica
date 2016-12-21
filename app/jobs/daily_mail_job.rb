class DailyMailJob < ApplicationJob
  queue_as :default

  def perform
    send_digest
  end

  def send_digest
    User.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
