require 'acceptance_helper'

feature 'Delete file attached to the answer', %q{
  In order to remove attachment
} do
  include_context 'users'

  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:answer_attachment) { create(:answer_attachment, attachable_id: answer.id) }

  scenario 'User deletes file attached to his answer', js: true do
    visit_user(user)

    within '.answer-rendered-attachment' do
      click_on '[x]'
    end

    expect(page).to_not have_link('file1.txt', href: '/uploads/attachment/file/1/file1.txt')
  end

  scenario 'User tries to delete file attached to other user`s answer', js: true do
    visit_user(john)

    within '.answer-rendered' do
      expect(page).to_not have_link '[x]'
    end
  end

  scenario 'Anonymous can`t see remove button' do
    visit_quest

    expect(page).to_not have_link('[x]')
  end
end
