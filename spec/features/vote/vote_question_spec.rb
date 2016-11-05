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

    click_on 'vote up'

    within "#rating-#{question.id}" do
      expect(page).to have_text('1')
    end

    click_on 'vote up'
    sleep(1)

    within "#rating-#{question.id}" do
      expect(page).to have_text('1')
    end

    click_on 'vote down'
    sleep(1)

    within "#rating-#{question.id}" do
      expect(page).to have_text('-1')
    end

    click_on 'vote down'
    sleep(1)

    within "#rating-#{question.id}" do
      expect(page).to have_text('-1')
    end

  end

  scenario 'Owner user tries to vote for question', js: true do
    login_as(owner)
    visit question_path(question)

    expect(page).to_not have_text 'vote up'
    expect(page).to_not have_text 'vote down'
    expect(page).to_not have_text 'vote cancel'
  end


  scenario 'Non-Authorized user tries to vote for question', js: true do
    visit question_path(question)

    expect(page).to_not have_text 'vote up'
    expect(page).to_not have_text 'vote down'
    expect(page).to_not have_text 'vote cancel'
  end
end
