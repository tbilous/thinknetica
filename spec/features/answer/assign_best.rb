require 'acceptance_helper'

feature 'Assign complete answer', %q{
  In order to inform other users
  As question user
  I want to Assign the best answer for my question
} do
  include_context 'users'

  let(:question) { create(:question, user: user) }
  let!(:first_answer) { create(:answer, question: question, best: true, body: 'a' * 61) }
  let!(:second_answer) { create(:answer, question: question, body: 'b' * 61) }

  scenario 'not authorized user try assign best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Assign best'
  end

  scenario 'User try to change best answer', js: true do
    visit_user(user)

    click_link('Assign best')

    within(:css, '.answer-block:nth-of-type(1)') do
      expect(page).to have_content 'The best answer'
      expect(page).to have_content second_answer.body
    end

    within(:css, '.answer-block:nth-of-type(2)') do
      expect(page).to have_link 'Assign best'
      expect(page).to have_content first_answer.body
    end
  end

  scenario 'User tries to change the best answer of other user`s question', js: true do
    visit_user(john)

    expect(page).to_not have_link 'Assign best'
  end
end
