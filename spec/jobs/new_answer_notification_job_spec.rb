require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  include_context 'users'

  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: john) }
  describe do
    let(:users) { [user, tom, john] }

    it 'sends notification' do
      Subscription.create(user: john, question: question)
      Subscription.create(user: tom, question: question)

      users.each do |user|
        expect(QuestionSubscriptionMailer).to receive(:notification_email).with(user, answer).and_call_original
      end
      NewAnswerNotificationJob.perform_now(answer)
    end
  end
end
