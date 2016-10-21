require 'rails_helper'

feature 'non autirized user see questions and answers ', %q{
  User see list of questions
  User cant see answer form
  user cant see answer delete link
} do
  let(:question_params) { FactoryGirl.attributes_for(:question) }

  scenario 'not authorized user on  site' do
    question = Question.create!(title: question_params[:title], body: question_params[:body])
    question2 = Question.create!(title: (question_params[:title] + 'b'), body: (question_params[:body] + 'b'))
    answer = question.answers.create!(body: question_params[:body])
    visit root_path
    expect(page).to have_content question.title
    expect(page).to have_content question2.title
    click_on(question_params[:title], match: :first)
    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Write answer'
    expect(page).to_not have_link 'Delete answer'
  end
end

feature 'authorized users can make an answer', %q{
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

  scenario 'User can to create an answer' do
    Question.create!(title: question_params[:title], body: question_params[:body])
    visit root_path
    click_on question_params[:title]
    expect(page).to have_content 'Write answer'
    fill_in 'answer_body', with: question_params[:body]
    click_button 'Add answer'
    expect(page).to have_css('.alert-success')
  end

  scenario 'User can to edit  an answer' do
    question = Question.create!(title: question_params[:title], body: question_params[:body])
    answer = question.answers.create!(body: answer_params[:body], user_id: answer_params[:user_id])
    new_answer_params = answer_params[:body] + 'a'
    visit root_path
    click_on question_params[:title]
    expect(page).to have_content 'Edit answer'
    click_link('Edit answer', href: edit_answer_path(answer))
    expect(page).to have_content 'Edit Answer'
    fill_in 'answer_body', with: new_answer_params
    click_on 'Save'
    expect(page).to have_content new_answer_params
    expect(page).to have_css('.alert-success')
  end

  scenario 'User can to delete an answer' do
    question = Question.create!(title: question_params[:title], body: question_params[:body])
    question.answers.create!(body: answer_params[:body], user_id: answer_params[:user_id])
    visit root_path
    click_on question_params[:title]
    click_link('Delete answer', match: :first)
    expect(page).to have_css('.alert-success')
  end

  scenario 'user dont have links to edit and delete other users records' do
    question = user.questions.create(title: question_params[:title], body: question_params[:body])
    question.answers.create(body: answer_params[:body])
    login_as(other_user, scope: :user)
    visit root_path
    click_on question_params[:title]
    expect(page).to_not have_content 'Delete answer'
    expect(page).to_not have_content 'Edit answer'
  end
end
