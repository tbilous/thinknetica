require 'rails_helper'

feature 'Delete file attached to the question', %q{
  In order to remove attachment
} do

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:question_attachment) { create(:question_attachment, attachable_id: question.id) }

  scenario 'User deletes file attached of his question', js: true do
    login_as(user)
    visit question_path(question)

    within '.attachments-block' do
      click_on '[x]'
    end

    expect(page).to_not have_link('file1.txt', href: '/uploads/attachment/file/1/file1.txt')
  end

  scenario 'User tries to delete attach of other user`s question', js: true do
    login_as(other_user)
    visit question_path(question)
    # sleep(inspection_time=15)

    expect(page).to_not have_link '[x]'
  end
  scenario 'Anonymous can`t see remove button' do
    visit question_path(question)

    expect(page).to_not have_link('[x]')
  end
end
