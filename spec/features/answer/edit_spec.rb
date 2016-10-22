require 'rails_helper'

feature 'Author can delete answers', %q{
  In order to hide my wrong answer
  As an author
  I want to have an ability to delete it
} do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:new_answer_params) { answer.body + 'a' }

  scenario 'Author of answer edit it' do
    login_as(user, scope: :user)
    visit question_path(question)

    expect(page).to have_link 'Edit answer'

    click_link('Edit answer', href: edit_answer_path(answer))
    fill_in 'answer_body', with: new_answer_params
    click_on 'Save'

    expect(page).to have_content new_answer_params
    expect(page).to have_css('.alert-success')
  end

  scenario 'Author of answer tries to edit answer with invalid data' do
    login_as(user, scope: :user)
    visit edit_answer_path(answer)

    fill_in 'answer_body', with: 'a' * 2
    click_button 'Save'

    expect(page).to have_css('.alert-danger')

    expect(current_path).to eq answer_path(answer)
  end

  scenario 'User tries to edit answer of another user' do
    login_as(other_user, scope: :user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
end
