require 'acceptance_helper'

feature 'List questions', %q{
  In order to find interesting content
  As a user
  I want to view questions list
} do

  let!(:questions) { create_list(:question, 5) }

  scenario 'User views the list of questions' do
    visit questions_path
    expect(page).to have_selector '.questions-list'

    within '.questions-list' do
      questions.each do |q|
        expect(page).to have_text q.created_at.strftime('%Y-%m-%d')
        expect(page).to have_link q.title
      end
    end
  end
end
