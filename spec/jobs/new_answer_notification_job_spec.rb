require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  include_context 'users'

  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: john) }
  let!(:subscription) { create(:subscription, user: user, question: question) }

  it 'sends notification' do
    expect(QuestionSubscriptionMailer).to receive(:notification_email).with(user, answer).and_call_original
    NewAnswerNotificationJob.perform_now(answer)
  end
end
