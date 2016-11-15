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
  context 'user can to create comment' do
    scenario 'authorized user can to create comment for question', :aggregate_failures, :js do
      login_as(user)
      visit question_path(question)

      page.find("#comment-question-#{question.id}").click

      within '#NewQuestionComment' do
        fill_in 'comment_body', with: comment_attrib[:body]
        find('.btn').trigger('click')
      end

      within "#QuestionCommentsList-#{question.id}" do
        expect(page).to have_content comment_attrib[:body]
      end
    end

    scenario 'user can`t create comment when his not authorized', :aggregate_failures, :js do
      within '.question-block' do
        expect(page).to_not have_css("#comment-question-#{question.id}")
      end
    end
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
  end
end
