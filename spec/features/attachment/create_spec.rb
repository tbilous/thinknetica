
feature 'Add attachment', %q{
  In order to add attachments for question
  With create form
  With create answer
} do
  let!(:user) { create(:user) }

  scenario 'user can add attachment when create question' do
    login_as(user)
    visit root_path

    # fill_in 'question_title', with: question_params[:title]
    # fill_in 'question_body', with: question_params[:body]
    # within all('.nested-fields').first do
    #   attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    # end

    # click_on 'add file'

  end
end