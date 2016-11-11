require 'acceptance_helper'

feature 'Vote answer', %q{
  Authorized User can vote for answer
  User can vote positive or negative only one time
  The Owner has not have rights for vote
} do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question)   { create(:question, user: user) }
  let!(:answer)    { create(:answer, question: question, user: other_user) }

  scenario 'User votes for the answer', js: true do
    login_as(user)
    visit question_path(question)
    # sleep(inspection_time=25)

    page.find("#vote-plus-#{answer.id}").click

    within ".answer-block #rating-#{answer.id}" do
      expect(page).to have_text('1')
    end

    page.find("#vote-plus-#{answer.id}").click
    sleep(1)

    within ".answer-block #rating-#{answer.id}" do
      expect(page).to have_text('1')
    end
    expect(page).to have_css("#vote-cancel-#{answer.id}")

    page.find("#vote-minus-#{answer.id}").click
    sleep(1)

    within ".answer-block #rating-#{answer.id}" do
      expect(page).to have_text('-1')
    end

    page.find("#vote-minus-#{answer.id}").click
    sleep(1)

    within ".answer-block #rating-#{answer.id}" do
      expect(page).to have_text('-1')
    end
    expect(page).to have_css("#vote-cancel-#{answer.id}")

    page.find("#vote-cancel-#{answer.id}").click

    within ".answer-block #rating-#{answer.id}" do
      expect(page).to have_text('0')
    end
    sleep(1)

    expect(page).to have_css("#vote-cancel-#{answer.id}",  visible: false)
  end

  scenario 'Owner user tries to vote for answer', js: true do
    login_as(other_user)
    visit question_path(question)

    within '.answer-block' do
      expect(page).to_not have_css("#vote-plus-#{answer.id}")
      expect(page).to_not have_css("#vote-minus-#{answer.id}")
      expect(page).to_not have_css("#vote-cancel-#{answer.id}")
    end
  end

  scenario 'Non-Authorized user tries to vote for answer', js: true do
    visit question_path(question)

    within '.answer-block' do
      expect(page).to_not have_css("#vote-plus-#{answer.id}")
      expect(page).to_not have_css("#vote-minus-#{answer.id}")
      expect(page).to_not have_css("#vote-cancel-#{answer.id}")
    end
  end
end
