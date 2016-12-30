require 'rails_helper'

RSpec.describe QuestionSubscriptionMailer, type: :mailer do
  include_context 'users'

  describe 'mail when created answer' do
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: john) }
    let(:mail) { QuestionSubscriptionMailer.notification_email(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('See new answer')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello #{user.name}, you have new answer")
      expect(mail.body.encoded).to have_link(answer.body.truncate(20), href: question_url(answer, locale: I18n.locale))
    end
  end
end
