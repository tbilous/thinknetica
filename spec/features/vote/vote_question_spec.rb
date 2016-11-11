require 'acceptance_helper'

feature 'Vote question', %q{
  Authorized User can vote for question
  User can vote positive or negative only one time
  The Owner has not have rights for vote
} do

  let(:user) { create(:user) }
  let(:owner) { create(:user) }
  let(:question) { create(:question, user: owner) }

  scenario 'User votes for the question', js: true do
    login_as(user)
    visit question_path(question)
    # sleep(inspection_time=25)

    page.find("#vote-plus-#{question.id}").click

    within "#rating-#{question.id}" do
      expect(page).to have_text('1')
    end

    page.find("#vote-plus-#{question.id}").click
    sleep(1)

    within "#rating-#{question.id}" do
      expect(page).to have_text('1')
    end
    expect(page).to have_css("#vote-cancel-#{question.id}")

    page.find("#vote-minus-#{question.id}").click
    sleep(1)

    within "#rating-#{question.id}" do
      expect(page).to have_text('-1')
    end

    page.find("#vote-minus-#{question.id}").click
    sleep(1)

    within "#rating-#{question.id}" do
      expect(page).to have_text('-1')
    end
    expect(page).to have_css("#vote-cancel-#{question.id}")

    page.find("#vote-cancel-#{question.id}").click

    within "#rating-#{question.id}" do
      expect(page).to have_text('0')
    end
    sleep(1)

    expect(page).to have_css("#vote-cancel-#{question.id}",  visible: false)
  end

  scenario 'Owner user tries to vote for question', js: true do
    login_as(owner)
    visit question_path(question)

    expect(page).to_not have_css("#vote-plus-#{question.id}")
    expect(page).to_not have_css("#vote-minus-#{question.id}")
    expect(page).to_not have_css("#vote-cancel-#{question.id}")
  end

  scenario 'Non-Authorized user tries to vote for question', js: true do
    visit question_path(question)

    expect(page).to_not have_css("#vote-plus-#{question.id}")
    expect(page).to_not have_css("#vote-minus-#{question.id}")
    expect(page).to_not have_css("#vote-cancel-#{question.id}")
  end
end
