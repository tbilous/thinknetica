require 'rails_helper'

feature 'Author can edit question', %q{
  In order to edit my question
  As an author
  I want to have an ability to edit it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  let(:new_question_params) do
    { body: question.title + 'a' }
    { body: question.body + 'a' }
  end

  scenario 'Author of question edits it' do
    login_as(user)
    visit question_path(question)
    click_on 'Edit question'

    fill_in 'question_title', with: new_question_params[:title]
    fill_in 'question_body', with: new_question_params[:body]
    click_on 'Save'

    expect(page).to have_content new_question_params[:title]
    expect(page).to have_content new_question_params[:body]
    expect(current_path).to match /^\/questions\/\d+$/
  end

  scenario 'User tries to edit question of another user' do
    login_as(user)
    someones_question = create(:question)
    visit question_path(someones_question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

end