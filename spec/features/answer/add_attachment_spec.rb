require 'acceptance_helper'

feature 'Add attachment', %q{
  In order to add attachments for answer
} do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer_params) { attributes_for(:answer) }

  scenario 'user can add attachment when create answer', js: true do
    login_as(user)
    visit question_path(question)

    fill_in 'answer_body', with: answer_params[:body]

    page.find('.attach-file-answer').click

    within all('.nested-fields').first do
      attach_file 'attachment', "#{Rails.root}/spec/support/for_upload/file1.txt"
    end

    page.find('.attach-file-answer').click

    within all('.nested-fields').last do
      attach_file 'attachment', "#{Rails.root}/spec/support/for_upload/file2.txt"
    end

    within '#new_answer' do
      click_on 'submit'
    end
    within '.answer-rendered' do
      expect(page).to have_link('file1.txt', href: '/uploads/attachment/file/1/file1.txt')
      expect(page).to have_link('file2.txt', href: '/uploads/attachment/file/2/file2.txt')
    end
  end
end
