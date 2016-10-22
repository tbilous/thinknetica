require 'rails_helper'


feature 'Create answer', %q{
  In order to help another user
  As an authenticated user
  I want to answer the question
} do

  let!(:user) { create(:user) }
  let(:question) {create(:question) }
  let(:answer_params) { attributes_for(:answer, user_id: user.id) }


  before { login_as(user, scope: :user) }


  scenario 'Authenticated user creates answer with proper data' do
    visit question_path(question)

    fill_in 'answer_body', with: answer_params[:body]
    click_button 'Add answer'

    expect(page).to have_css('.alert-success')

    within '.alert-success' do
      expect(page).to have_content 'NICE'
    end
    expect(page).to have_content answer_params[:body]
  end

  scenario 'Authenticated user tries to create answer with invalid data' do
    visit question_path(question)

    fill_in 'answer_body', with: 'a'*2
    click_button 'Add answer'

    expect(page).to have_css('.alert-danger')

    expect(current_path).to eq question_answers_path(question)
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Add answer'
  end
end