require 'acceptance_helper'

feature 'Author can delete answers', %q{
  In order to hide my wrong answer
  As an author
  I want to have an ability to delete it
} do
  include_context 'users'

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:new_answer_params) { answer.body + 'a' }

  scenario 'Author of answer edit it', js: true do
    visit_user(user)

    page.find("#edit-answer-#{answer.id}").click

    within "#edit_answer_#{answer.id}" do
      fill_in 'answer_body', with: new_answer_params
      click_on 'submit'
    end

    expect(page).to have_content new_answer_params
  end

  scenario 'Author of answer tries to edit answer with invalid data', js: true do
    visit_user(user)

    page.find("#edit-answer-#{answer.id}").click

    within "#edit_answer_#{answer.id}" do
      fill_in 'answer_body', with: 'a' * 2
      click_button 'submit'
    end

    expect(page).to have_content(answer.body)
  end

  scenario 'User tries to edit answer of another user' do
    visit_user(john)

    expect(page).to_not have_css("#edit-answer-#{answer.id}")
  end

  scenario 'Non-authenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_css("#edit-answer-#{answer.id}")
  end
end
