require 'acceptance_helper'

feature 'Add comments for answer', %q{
  In order to add and delete comments for answer
  All user on question page see comment after his added
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:comment_attrib) { attributes_for(:comment) }



  background do
    visit question_path(question)
  end
  context 'user can to create comment' do
    scenario 'authorized user can to create comment for answer', :aggregate_failures, :js do
      login_as(user)
      visit question_path(question)

      page.find("#comment-answer-#{answer.id}").click

      within '#NewAnswerComment' do
        fill_in 'comment_body', with: comment_attrib[:body]
        find('.btn').trigger("click")
      end

      within "#AnswerCommentsList-#{answer.id}" do
        expect(page).to have_content comment_attrib[:body]
      end
    end

    scenario 'user can`t create comment when his not authorized', :aggregate_failures, :js do
      within '.question-block' do
        expect(page).to_not have_css("#comment-answer-#{answer.id}")
      end
    end
  end

  context 'user can to delete comment', :js do
    let(:other_user) { create(:user) }
    let!(:comment) { create(:comment, user:other_user, commentable: answer) }

    scenario 'authorized user can to delete his comment for answer' do
      login_as(other_user)
      visit question_path(question)

      expect(page).to have_css('.delete-comment-link')
      page.find('.delete-comment-link').click
      expect(page).to_not have_content(comment[:body])
    end

    scenario 'authorized user can`t to delete other user`s comment for answer' do
      login_as(user)
      visit question_path(question)

      within '.question-block' do
        expect(page).to_not have_css('delete-comment-link')
      end
    end

    scenario 'not authorized user can`t to delete comment for answer' do
      login_as(user)
      visit question_path(question)

      within '.question-block' do
        expect(page).to_not have_css('delete-comment-link')
      end
    end
  end

end
