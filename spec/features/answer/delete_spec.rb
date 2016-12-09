require 'acceptance_helper'

feature 'Author can delete answers', %q{
  In order to hide my wrong answer
  As an author
  I want to have an ability to delete it
} do
  include_context 'users'

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user, body: 'y' * 60) }
  context 'as user', :js do
    scenario 'Author of answer deletes it', js: true do
      visit_user(user)

      page.find("#delete-answer-#{answer.id}").click

      sleep 1

      expect(page).to_not have_content answer.body
      expect(current_path).to eq question_path(question)
    end

    scenario 'User tries to delete answer of another user', js: true do
      visit_user(john)

      expect(page).to_not have_css("#delete-answer-#{answer.id}")
    end

    scenario 'all users see as comment was removed real-time' do
      Capybara.using_session('author') do
        visit_user(user)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        page.find("#delete-answer-#{answer.id}").click
        sleep 1

        expect(page).to_not have_content answer.body
      end
      Capybara.using_session('guest') do
        expect(page).to_not have_content answer.body
      end
    end
  end

  context 'as guest', :js do
    scenario 'Non-authenticated user tries to delete answer', js: true do
      visit question_path(question)

      expect(page).to_not have_css("#delete-answer-#{answer.id}")
    end
  end
end
