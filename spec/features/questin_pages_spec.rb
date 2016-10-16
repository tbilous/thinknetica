require 'rails_helper'

feature 'user can to create question', %q{
  User see form for question on root page
  User can to create question
  User can see list of the questions with title and date
  User can to visit to page of question after click on the title in the list
  User can to see on the page of question a title and a body
  User can delete the question on question's page
  User can to delete the question on question's page and will be redirected to root after that
  When question was created, updated, deletes user see 'flash' message about this action
} do
  scenario 'user see form on root page and  make question' do
    visit root_path
    expect(page).to have_content 'Create question'
  end

end

feature 'user can to create answer', %q{
  User can to write an answer on question's page
  User can to see a list of the answers on question's page
  User can to edit the answer
  User can to delete the answer
} do

end

feature 'registration and authorization', %q{
  User can to register in app and sign in
  Authorized user have profile page
  Only authorized user can see form of new question and create question
  Only authorized user can to create answer
  User can to delete and to edit only his questions
  User can to delete and to edit only his answers
} do

end