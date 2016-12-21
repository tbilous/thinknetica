require 'rails_helper'

RSpec.describe DailyMailJob, type: :job do
  include_context 'users'
  let!(:users) { [user, tom, john] }

  it 'sends daily digest' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end

    DailyMailJob.perform_now
  end
end
