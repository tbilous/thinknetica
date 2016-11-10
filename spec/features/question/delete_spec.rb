require 'acceptance_helper'

feature 'Author can delete question', %q{
  In order to cancel my question
  As an author
  I want to have an ability to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Author of question deletes it' do
    login_as(user)
    visit question_path(question)

    page.find("#delete-question-#{question.id}").click

    expect(page).to_not have_content question.title
    expect(current_path).to eq root_path
  end

  scenario 'User tries to delete question of another user' do
    login_as(user)
    someones_question = create(:question)
    visit question_path(someones_question)

    expect(page).to_not have_css("#delete-question-#{question.id}")
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_css("#delete-question-#{question.id}")
  end
end
