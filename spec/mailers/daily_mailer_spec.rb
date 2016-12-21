require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe 'DailyMailer.digest' do
    include_context 'users'

    describe 'when yesterday had a question' do
      let!(:question) { create(:question, created_at: 1.day.ago, user: user) }
      let(:mail) { DailyMailer.digest(user) }

      it 'renders the headers' do
        expect(mail.subject).to eq('Digest')
        expect(mail.to).to eq([user.email])
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match("Hello, #{user.name}")
      end
    end

    describe 'when yesterday was not had a question' do
      let!(:questions) { create(:question, user: user) }

      let(:users) { [user, john, tom] }
      it do
        users.each do |user|
          expect do
            DailyMailer.digest(user)
          end.not_to change(ActionMailer::Base.deliveries, :count)
        end
      end
    end
  end
end
