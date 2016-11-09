require 'acceptance_helper'

feature 'Create question', %q{
  In order to solve my problem with help of community
  As an authenticated user
  I want to ask a question
} do

  given(:user) { create(:user) }
  let(:question_params) { attributes_for(:question) }

  scenario 'Authenticated user creates question with proper data' do
    login_as(user)
    visit questions_path

    page.find("#add_question_btn").click

    fill_in 'question_title', with: question_params[:title]
    fill_in 'question_body', with: question_params[:body]
    click_on 'submit'

    expect(page).to have_content question_params[:title]
    expect(page).to have_content question_params[:body]
  end

  scenario 'Authenticated user tries to create question with invalid data', js: true do
    login_as(user)
    visit questions_path

    page.find("#add_question_btn").click

    fill_in 'question_title', with: 'b' * 2
    fill_in 'question_body', with: 'b' * 2
    click_on 'submit'

    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user tries to create question' do
    visit root_path

    expect(page).to_not have_css('#new_question')
  end
end
