require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe DailyMailWorker, type: :worker do
  Sidekiq::Testing.inline! do
    DailyMailWorker.perform_async

    include_context 'users'
    let!(:users) { [user, tom, john] }

    it 'should sent daily digest to all users' do
      users.each { |user|
        expect(DailyMailer).to receive(:digest).with(user).and_call_original
      }
      User.send_daily_digest
    end
  end
end
