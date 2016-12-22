require 'sphinx_acceptance_helper'

feature 'Search', %(
  In order to be able to search resource
  As an user
  I'd like to be able to search for resources
) do
  include_context 'users'

  let!(:question_01) { create(:question, title: 'Question with search', user: user) }
  let!(:answer_01) { create(:answer, body: 'Answer with search') }
  let!(:comment_01) { create(:comment,
                             body: 'Comment with search',
                             commentable_type: 'Question',
                             commentable_id: question_01.id
  ) }
  let!(:comment_02) { create(:comment,
                             body: 'Comment with search',
                             commentable_type: 'Answer',
                             commentable_id: answer_01.id
  ) }

  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:comment) { create(:comment,
                          commentable_type: 'Question',
                          commentable_id: question_01.id
  ) }

  let!(:shadow_user) { john }

  background do
    index
    visit(root_path)
  end

  scenario 'can search from all resources', :js do
    fill_in 'q', with: 'search'
    select 'All', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 4)
      expect(page).to have_content(question_01.title)
      expect(page).to have_content(answer_01.body)
      expect(page).to have_content(comment_01.body)
      expect(page).to have_content(comment_02.body)
    end
  end

  scenario 'can search from questions', :js do
    fill_in 'q', with: 'search'
    select 'Question', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 1)
      expect(page).to have_content(question_01.title)
    end
  end

  scenario 'can search answers', :js do
    fill_in 'q', with: 'search'
    select 'Answer', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 1)
      expect(page).to have_content(answer_01.body)
    end
  end

  scenario 'can search comments', :js do
    fill_in 'q', with: 'search'
    select 'Comment', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 2)
      expect(page).to have_content(comment_01.body)
      expect(page).to have_content(comment_02.body)
    end
  end

  scenario 'can search users', :js do
    fill_in 'q', with: user.email
    select 'Author', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 1)
      expect(page).to have_content(user.email)
    end
  end
end
