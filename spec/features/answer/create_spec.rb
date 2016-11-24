require 'acceptance_helper'

feature 'Create answer', %q{
  In order to help another user
  As an authenticated user
  I want to answer the question
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer_params) { attributes_for(:answer) }
  context 'as user', :js do
    scenario 'Authenticated user creates answer with proper data' do
      login_as(user)
      visit question_path(question)

      fill_in 'answer_body', with: answer_params[:body]
      within '#new_answer' do
        click_button('submit')
      end

      within '.answer-rendered' do
        expect(page).to have_content answer_params[:body]
      end

      expect(current_path).to eq question_path(question)
    end

    scenario 'all users see new question in real-time' do
      Capybara.using_session('author') do
        login_as(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        fill_in 'answer_body', with: answer_params[:body]
        within '#new_answer' do
          click_button('submit')
        end

        within '.answer-rendered' do
          expect(page).to have_content answer_params[:body]
        end
      end
      Capybara.using_session('guest') do
        within '.answer-rendered' do
          expect(page).to have_content answer_params[:body]
        end
      end
    end

    scenario 'Authenticated user tries to create answer with invalid data', js: true do
      login_as(user, scope: :user)
      visit question_path(question)

      fill_in 'answer_body', with: 'a' * 2

      within '#new_answer' do
        click_button('submit')
      end

      expect(current_path).to eq question_path(question)
    end
  end
  context 'as guest', :js do
    scenario 'Non-authenticated user tries to create answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Add answer'
    end
  end
end
