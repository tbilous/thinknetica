class DailyMailWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 3

  def perform
    send_digest
  end

  def send_digest
    User.find_each do |user|
      DailyMailer.digest(user).deliver
    end
  end
end
