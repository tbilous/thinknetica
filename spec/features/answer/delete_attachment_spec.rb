require 'acceptance_helper'

feature 'Delete file attached to the answer', %q{
  In order to remove attachment
} do

  let!(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:answer_attachment) { create(:answer_attachment, attachable_id: answer.id) }

  scenario 'User deletes file attached to his answer', js: true do
    login_as(user)
    visit question_path(question)

    within '.answer-rendered-attachment' do
      click_on '[x]'
    end

    expect(page).to_not have_link('file1.txt', href: '/uploads/attachment/file/1/file1.txt')
  end

  scenario 'User tries to delete file attached to other user`s answer', js: true do
    login_as(other_user)
    visit question_path(question)

    within '.answer-rendered' do
      expect(page).to_not have_link '[x]'
    end
  end

  scenario 'Anonymous can`t see remove button' do
    visit question_path(question)

    expect(page).to_not have_link('[x]')
  end
end
