require 'acceptance_helper'
require 'capybara/email'

feature 'User gets digest email', %q{
  User able go to question through links
 } do

  include_context 'users'
  let!(:question) { create(:question, created_at: 1.day.ago, user: user) }

  background do
    clear_emails
    DailyMailer.digest(user).deliver_now
    open_email(user.email)
  end

  scenario 'User gets digest email' do
    open_email(user.email)

    expect(current_email.body).to have_content question.title
    expect(current_email.body).to have_content question.body.truncate(20)
    current_email.click_link question.title

    expect(page).to have_content question.body
  end
end
