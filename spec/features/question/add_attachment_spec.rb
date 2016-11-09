feature 'Add attachment', %q{
  In order to add attachments for question
  With create question
  With create answer
} do
  let!(:user) { create(:user) }
  let(:question_params) { attributes_for(:question) }

  scenario 'user can add attachment when create question', js: true do
    login_as(user)
    visit questions_path

    page.find("#add_question_btn").click

    fill_in 'question_title', with: question_params[:title]
    fill_in 'question_body', with: question_params[:body]

    # click_on 'ADD FILE'
    page.find(".add_fields").click

    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/support/for_upload/file1.txt"
    end

    page.find(".add_fields").click

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/support/for_upload/file2.txt"
    end

    click_on 'Add question'

    within '.attachments-block' do
      expect(page).to have_link('file1.txt', href: '/uploads/attachment/file/1/file1.txt')
      expect(page).to have_link('file2.txt', href: '/uploads/attachment/file/2/file2.txt')
    end
  end
end
