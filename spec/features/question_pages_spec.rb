require 'rails_helper'
feature 'user can to create question', %q{
  Root page have Home page in title
  User see form for question on root page
  User can to create question
  User can see list of the questions with title and date
  User can to visit to page of question after click on the title in the list
  User can edit the question
  User can to delete the question on question's page and will be redirected to root after that
  When question was created, updated, deletes user see 'flash' message about this action
} do
  let(:question_params) { FactoryGirl.attributes_for(:question) }
  scenario 'Root page have title' do
    visit root_path
    expect(page).to have_title 'Home page'
  end
  scenario 'user see form on root page and can will create and destroy a question' do
    visit root_path
    expect(page).to have_title 'Home page'
    fill_in 'question_title', with: question_params[:title]
    fill_in 'question_body', with: question_params[:body]
    click_on 'Add question'
    expect(page).to have_css('.alert-success')
    click_link 'Delete question'
    expect(page).to have_title 'Home page'
  end
  scenario 'user has created the question' do
    question = Question.create!(title: question_params[:title], body: question_params[:body] )
    visit root_path
    expect(page).to have_content question_params[:title]
    click_on question_params[:title]
    expect(page).to have_title question_params[:title]
    expect(page).to have_content question_params[:title]
    expect(page).to have_content question_params[:body]
    click_link('', href: edit_question_path(question))
    fill_in 'question_title', with: question_params[:title] + 'a'
    fill_in 'question_body', with: question_params[:body] + 'a'
    click_on 'Save'
    expect(page).to have_content question_params[:title] + 'a'
  end
end

feature 'user can to create answer', %q{
  User can to write an answer on question's page
  User can to see a list of the answers on question's page
  User can to edit the answer
  User can to delete the answer
  When answer was created, updated, deletes user see 'flash' message about this action
} do
  let(:question_params) { FactoryGirl.attributes_for(:question) }
  scenario do
    Question.create!(title: question_params[:title], body: question_params[:body] )
    visit root_path
    click_on question_params[:title]
    expect(page).to have_content 'Write answer'
    fill_in 'answer_body', with: question_params[:body]
    click_button 'Add answer'
    expect(page).to have_css('.alert-success')
    click_on 'Delete answer'
    expect(page).to have_css('.alert-success')
  end
end

feature 'registration and authorization', %q{
  User can to register in app and sign in
  Authorized user have profile page
  Only authorized user can see form of new question and create question
  Only authorized user can to create answer
  User can to delete and to edit only his questions
  User can to delete and to edit only his answers
} do
  scenario do
  end
end