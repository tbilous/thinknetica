require 'rails_helper'

feature 'Author can edit question', %q{
  In order to edit my question
  As an author
  I want to have an ability to edit it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  let(:new_question_params) do
    { title: 'b' * 6, body: 'b' * 61 }
  end

  scenario 'Author of question edits it', js: true  do
    login_as(user)
    visit question_path(question)
    click_on 'Edit question'

    fill_in 'question_title', with: new_question_params[:title]
    fill_in 'question_body', with: new_question_params[:body]
    click_on 'Save'
    within '.question-block' do
      expect(page).to have_content new_question_params[:title]
      expect(page).to have_content new_question_params[:body]
    end
    expect(current_path).to match %r{/questions/}
  end

  scenario 'User tries to edit question of another user', js: true  do
    login_as(user)
    someones_question = create(:question)
    visit question_path(someones_question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario 'Non-authenticated user tries to delete question', js: true  do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
