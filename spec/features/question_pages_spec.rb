require 'rails_helper'
feature 'User is not authorized', %q{
  User can authorize
  User cant see form for question on root page
  User see list of questions and answer
  User see answer on question's page
  User cant see links for delete and write answers
} do
  let(:question_params) { FactoryGirl.attributes_for(:question) }

  scenario 'not authorized user on  site' do
    question = Question.create!(title: question_params[:title], body: question_params[:body])
    question2 = Question.create!(title: (question_params[:title] + 'b'), body: (question_params[:body] + 'b'))
    answer = question.answers.create!(body: question_params[:body])
    visit root_path
    expect(page).to have_link 'Sign'
    expect(page).to_not have_content 'Add question'
    expect(page).to have_content question.title
    expect(page).to have_content question2.title
    click_on(question_params[:title], match: :first)
    expect(page).to have_content answer.body
    expect(page).to have_content question.body
    expect(page).to_not have_content 'Write answer'
    expect(page).to_not have_link 'Delete answer'
  end
end

feature 'user is authorized', %q{
  User can create question
  User can visit to page of question after click on the title in the list
  User can edit the question
  User can delete the question on question's page and will be redirected to root after that
  When question was created, updated, deletes user see 'flash' message about this action
} do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user) }
  before { login_as(user, scope: :user) }
  let(:question_params) { FactoryGirl.attributes_for(:question) }
  let(:answer_params) { FactoryGirl.attributes_for(:answer, user_id: user.id) }

  scenario 'authorized user can create a question' do
    visit root_path
    expect(page).to_not have_link 'Sign'
    fill_in 'question_title', with: question_params[:title]
    fill_in 'question_body', with: question_params[:body]
    click_on 'Add question'
    expect(page).to have_css('.alert-success')
  end

  scenario 'authorized user can delete a question' do
    user.questions.create(title: question_params[:title], body: question_params[:body])
    visit root_path
    click_on question_params[:title]
    click_link 'Delete question'
    expect(page).to have_css('.alert-success')
    expect(page).to have_title 'Home page'
  end

  scenario 'user can edit his question' do
    user.questions.create(title: question_params[:title], body: question_params[:body])
    new_question_params = question_params[:title] + 'a'
    visit root_path
    click_link(question_params[:title])
    expect(page).to have_title question_params[:title]
    expect(page).to have_content question_params[:title]
    expect(page).to have_content question_params[:body]
    click_on 'Edit question'
    fill_in 'question_title', with: new_question_params
    fill_in 'question_body', with: new_question_params
    click_on 'Save'
    expect(page).to have_content new_question_params
  end

  scenario 'user dont have links to edit and delete other users records' do
    question = user.questions.create(title: question_params[:title], body: question_params[:body])
    question.answers.create(body: answer_params[:body])
    login_as(other_user, scope: :user)
    visit root_path
    click_on question_params[:title]
    expect(page).to_not have_content 'Delete question'
    expect(page).to_not have_content 'Edit question'
  end
end
