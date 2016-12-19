require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe DailyMailWorker, type: :worker do
  Sidekiq::Testing.inline! do
    include_context 'users'

    let!(:question) { create(:question, created_at: 1.day.ago, user: user) }

    it 'should start job' do
      expect { DailyMailWorker.perform_async }.to change(DailyMailWorker.jobs, :size).by(1)
    end
  end
  #
  #   describe do
  #       before {DailyMailWorker.perform_async}
  #
  #       include_context 'users'
  #
  #       it 'should sent daily digest to all users' do
  #         expect(DailyMailer).to receive(:digest).with(user).and_call_original
  #       end
  #   end
end
