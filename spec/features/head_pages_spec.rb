require 'rails_helper'
feature 'Attributes of pages', %q{
  All pages have title
} do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Root page have title' do
    visit root_path
    expect(page).to have_title t('page.home')
  end
  scenario 'Question page have title' do
    visit question_path(question)
    expect(page).to have_title 'Question page'
  end
end
