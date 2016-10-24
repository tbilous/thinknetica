require 'rails_helper'

feature 'Create answer', %q{
  In order to help another user
  As an authenticated user
  I want to answer the question
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer_params) { attributes_for(:answer) }

  scenario 'Authenticated user creates answer with proper data', js:true do
    login_as(user)
    visit question_path(question)

    fill_in 'answer_body', with: answer_params[:body]
    # sleep(inspection_time=5)
    click_button('Add answer')

    within '.answer-body' do
      expect(page).to have_content answer_params[:body]
    end

    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to create answer with invalid data', js:true do
    login_as(user, scope: :user)
    visit question_path(question)

    fill_in 'answer_body', with: 'a' * 2
    click_button 'Add answer'

    expect(page).to have_css('.alert-danger')
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to create answer', js:true do
    visit question_path(question)

    expect(page).to_not have_content 'Add answer'
  end
end
