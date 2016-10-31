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

    click_on 'add file'

    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/support/for_upload/file1.txt"
    end

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/support/for_upload/file2.txt"
    end

    click_on 'Add answer'

    within '.answer-rendered' do
      expect(page).to have_link('file1.txt', href: '/uploads/attachment/file/1/file1.txt')
      expect(page).to have_link('file2.txt', href: '/uploads/attachment/file/2/file2.txt')
    end
  end
end