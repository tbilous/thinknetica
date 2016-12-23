require 'sphinx_acceptance_helper'

feature 'Search', %(
  In order to be able to search resource
  As an user
  I'd like to be able to search for resources
) do
  include_context 'users'

  let!(:question) { create(:question, title: 'Question with search', user: user) }
  let!(:answer) { create(:answer, body: 'Answer with search', user: user) }
  let!(:comment_01) do
    create(:comment,
           body: 'Comment with search',
           commentable_type: 'Question',
           user: user,
           commentable_id: question.id)
  end
  let!(:comment_02) do
    create(:comment,
           body: 'Comment',
           commentable_type: 'Answer',
           user: user,
           commentable_id: answer.id)
  end

  background do
    index
    visit(root_path)
  end

  scenario 'can search from all resources', :js do
    select 'All', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 6)
      expect(page).to have_content(question.title)
      expect(page).to have_content(answer.body)
      expect(page).to have_content(comment_01.body)
      expect(page).to have_content(comment_02.body)
      expect(page).to have_content(user.email)
    end
  end

  scenario 'can search from questions', :js do
    fill_in 'q', with: 'search'
    select 'Question', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 1)
      expect(page).to have_content(question.title)
    end
  end

  scenario 'can search answers', :js do
    fill_in 'q', with: 'search'
    select 'Answer', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 1)
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'can search comments', :js do
    fill_in 'q', with: 'search'
    select 'Comment', from: 'object'
    click_button 'Search'

    within '.searches-list' do
      expect(page).to have_selector('.search-item', count: 1)
      expect(page).to have_content(comment_01.body)
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
