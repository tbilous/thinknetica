require 'rails_helper'
feature 'not authorized user cant to create question', %q{
  Root page have Home page in title
  User dont see form for question on root page
  User can see list of the questions with title and date
  User can to visit to page of question after click on the title in the list
  User cant see link for edit and delete the question
} do
  let(:question_params) { FactoryGirl.attributes_for(:question) }
  scenario 'Root page have title' do
    visit root_path
    expect(page).to have_title 'Home page'
  end
  scenario 'user cant see question form' do
    visit root_path
    expect(page).to have_link 'Sign'
    expect(page).to_not have_content 'Add question'
  end
end

feature 'not authorized user cant to create answer', %q{
  User see list of questions
  User cant see answer form
  user cant see answer delete link
} do
  let(:question_params) { FactoryGirl.attributes_for(:question) }
  scenario do
    question = Question.create!(title: question_params[:title], body: question_params[:body])
    question.answers.create!(body: question_params[:body])
    visit root_path
    click_on question_params[:title]
    expect(page).to_not have_content 'Write answer'
    expect(page).to_not have_link 'Delete answer'
  end
end

feature 'authorized have rights on create and edit question', %q{
  User see form for question on root page
  User can to create question
  User can see list of the questions with title and date
  User can to visit to page of question after click on the title in the list
  User can edit the question
  User can to delete the question on question's page and will be redirected to root after that
  When question was created, updated, deletes user see 'flash' message about this action
  User can to create an answer on question's page
  User can to see a list of the answers on question's page
  User can to delete the answer
  User dont have links to edit and delete other users records
  When answer was created, deletes user see 'flash' message about this action
} do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user) }
  before { login_as(user, scope: :user) }
  let(:question_params) { FactoryGirl.attributes_for(:question) }
  let(:answer_params) { FactoryGirl.attributes_for(:answer, user_id: user.id) }

  scenario 'user see form on root page and can to create and to destroy the question' do
    visit root_path
    expect(page).to_not have_link 'Sign'
    fill_in 'question_title', with: question_params[:title]
    fill_in 'question_body', with: question_params[:body]
    click_on 'Add question'
    expect(page).to have_css('.alert-success')
    click_link 'Delete question'
    expect(page).to have_css('.alert-success')
    expect(page).to have_title 'Home page'
  end

  scenario 'user can edit his question' do
    question = user.questions.create(title: question_params[:title], body: question_params[:body])
    new_question_params = question_params[:title] + 'a'
    visit root_path
    expect(page).to have_content question_params[:title]
    click_on question_params[:title]
    expect(page).to have_title question_params[:title]
    expect(page).to have_content question_params[:title]
    expect(page).to have_content question_params[:body]
    click_link('', href: edit_question_path(question))
    fill_in 'question_title', with: new_question_params
    fill_in 'question_body', with: new_question_params
    click_on 'Save'
    expect(page).to have_content new_question_params
  end

  scenario 'User can to create, edit and delete an answer' do
    question = Question.create!(title: question_params[:title], body: question_params[:body])
    answer = question.answers.create!(body: answer_params[:body], user_id: answer_params[:user_id])
    new_answer_params = answer_params[:body] + 'a'
    visit root_path
    click_on question_params[:title]
    expect(page).to have_content 'Write answer'
    fill_in 'answer_body', with: question_params[:body]
    click_button 'Add answer'
    expect(page).to have_css('.alert-success')
    expect(page).to have_content 'Edit answer'
    click_link('Edit answer', href: edit_answer_path(answer))
    expect(page).to have_content 'Edit Answer'
    fill_in 'answer_body', with: new_answer_params
    click_on 'Save'
    expect(page).to have_content new_answer_params
    expect(page).to have_css('.alert-success')
    click_link('Delete answer', match: :first)
    expect(page).to have_css('.alert-success')
  end

  scenario 'user dont have links to edit and delete other users records' do
    question = user.questions.create(title: question_params[:title], body: question_params[:body])
    question.answers.create(body: answer_params[:body])
    login_as(other_user, scope: :user)
    visit root_path
    click_on question_params[:title]
    expect(page).to_not have_content 'Delete question'
    expect(page).to_not have_content 'Edit question'
    expect(page).to_not have_content 'Delete answer'
    expect(page).to_not have_content 'Edit answer'
  end
end
