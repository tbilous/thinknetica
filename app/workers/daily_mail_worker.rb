class DailyMailWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 12

  def self.generate_all
    send_digest
  end

  def self.send_digest
    sidekiq_options queue: :daily

    User.find_each do |user|
      DailyMailWorker.perform(user)
    end
  end

  def perform(user)
    return unless user
    DailyMailer.digest(user).perform
  end
end
