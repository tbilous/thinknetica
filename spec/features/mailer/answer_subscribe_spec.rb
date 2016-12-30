require 'acceptance_helper'
require 'capybara/email'

feature 'User gets digest email', %q{
  User able go to question through links
 } do

  include_context 'users'
  let(:question) { create(:question, created_at: 1.day.ago, user: user) }
  let!(:answer) { create(:answer, question: question, user: john) }

  background do
    clear_emails
    QuestionSubscriptionMailer.notification_email(user, answer).deliver_now
    open_email(user.email)
  end

  scenario 'User gets digest email' do
    expect(current_email).to have_content(answer.body.truncate(20))

    current_email.click_link(answer.body.truncate(20))

    expect(page).to have_content question.body
  end
end
