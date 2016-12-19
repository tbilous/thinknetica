require 'rails_helper'

RSpec.describe DailyMailJob, type: :job do
  include_context 'users'

  it 'sends daily digest' do
    expect(DailyMailer).to receive(:digest).with(user).and_call_original

    DailyMailJob.perform_now
  end
end
