require 'acceptance_helper'

feature 'Subscribe', %q{
  In order to add attachments for question
  With create question
  With create answer
} do

  include_context 'users'

  let!(:question) { create(:question, user: user) }
  let(:question_params) { attributes_for(:question) }

  scenario 'authorized user can subscribe on question ', js: true do
    login_as(john)
    visit question_path(question.id)

    page.find('a', text: 'subscribe').click
    expect(page).to have_link('unsubscribe')
  end

  scenario 'question`s owner can change subscription', :js do
    login_as(user)
    visit questions_path

    page.find('#add_question_btn').click

    fill_in 'question_title', with: question_params[:title]
    fill_in 'question_body', with: question_params[:body]
    click_on 'submit'

    page.find('a', text: 'unsubscribe').click
    expect(page).to have_link('subscribe')
  end
  scenario 'unauthorized user' do
    visit question_path(question.id)

    expect(page).to_not have_link('subscribe')
    expect(page).to_not have_link('unsubscribe')
  end
end
