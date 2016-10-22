require 'rails_helper'

feature 'Author can delete answers', %q{
  In order to hide my wrong answer
  As an author
  I want to have an ability to delete it
} do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) {create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author of answer deletes it' do
    login_as(user, scope: :user)
    visit question_path(question)

    expect(page).to have_link 'Delete'
    click_on 'Delete'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content answer.body
  end

  scenario 'User tries to delete answer of another user' do
    login_as(other_user, scope: :user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

end