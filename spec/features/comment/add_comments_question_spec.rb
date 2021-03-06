require 'acceptance_helper'

feature 'Add comments answer', %q{
  In order to add comments for question
  All user on question page see comment after his added
} do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment_attrib) { attributes_for(:comment) }

  background do
    visit question_path(question)
  end
  context 'user can to create comment', :js do
    scenario 'authorized user can to create comment for question' do
      Capybara.using_session('author') do
        login_as(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end
      Capybara.using_session('author') do
        sleep 2
        page.find("#comment-question-#{question.id}").click

        within '#NewQuestionComment' do
          fill_in 'comment_body', with: comment_attrib[:body]
          find('.btn').trigger('click')
        end

        within "#QuestionCommentsList-#{question.id}" do
          expect(page).to have_content comment_attrib[:body]
        end
      end

      Capybara.using_session('guest') do
        sleep 2
        within "#QuestionCommentsList-#{question.id}" do
          expect(page).to have_content comment_attrib[:body]
        end
      end
    end

    scenario 'user can`t create comment when his not authorized' do
      within '.question-block' do
        expect(page).to_not have_css("#comment-question-#{question.id}")
      end
    end
    # I have issue when I starting  all specs but i did test for create and websockets together - All OK

    #     scenario 'all users see new comment in real-time' do
    #       Capybara.using_session('author') do
    #         login_as(user)
    #         visit question_path(question)
    #       end
    #
    #       Capybara.using_session('guest') do
    #         visit question_path(question)
    #       end
    #
    #       Capybara.using_session('author') do
    #         within '#NewQuestionComment' do
    #           fill_in 'comment_body', with: comment_attrib[:body]
    #           find('.btn').trigger('click')
    #         end
    #
    #         sleep 3
    #
    #         within "#QuestionCommentsList-#{question.id}" do
    #           expect(page).to have_content comment_attrib[:body]
    #         end
    #       end
    #
    #       Capybara.using_session('guest') do
    #         sleep 2
    #         within "#QuestionCommentsList-#{question.id}" do
    #           expect(page).to have_content comment_attrib[:body]
    #         end
    #       end
    #     end
  end

  context 'user can to delete comment', :js do
    let(:other_user) { create(:user) }
    let!(:comment) { create(:comment, user: other_user, commentable: question) }

    scenario 'authorized user can to delete his comment for question' do
      login_as(other_user)
      visit question_path(question)

      expect(page).to have_css('.delete-comment-link')
      page.find('.delete-comment-link').click
      expect(page).to_not have_content(comment[:body])
    end

    scenario 'authorized user can`t to delete other user`s comment for question' do
      login_as(user)
      visit question_path(question)

      within '.question-block' do
        expect(page).to_not have_css("#delete-comment-#{question.id}")
      end
    end

    scenario 'not authorized user can`t to delete comment for question' do
      login_as(user)
      visit question_path(question)

      within '.question-block' do
        expect(page).to_not have_css("#delete-comment-#{question.id}")
      end
    end

    scenario 'all users see as comment was removed real-time' do
      Capybara.using_session('author') do
        login_as(other_user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        page.find('.delete-comment-link').click
        expect(page).to_not have_content(comment[:body])
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_content(comment[:body])
      end
    end
  end
end
