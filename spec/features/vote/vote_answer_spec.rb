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

    click_on 'vote up'

    within "#answer-rating-#{answer.id}" do
      expect(page).to have_text('1')
    end

    click_on 'vote up'
    sleep(1)

    within "#answer-rating-#{answer.id}" do
      expect(page).to have_text('1')
    end

    click_on 'vote down'
    sleep(1)

    within "#answer-rating-#{answer.id}" do
      expect(page).to have_text('-1')
    end

    click_on 'vote down'
    sleep(1)

    within "#answer-rating-#{answer.id}" do
      expect(page).to have_text('-1')
    end
  end

  scenario 'Owner user tries to vote for answer', js: true do
    login_as(other_user)
    visit question_path(question)

    within '.answer-block' do
      expect(page).to_not have_text('vote up')
      expect(page).to_not have_text('vote down')
      expect(page).to_not have_text('vote cancel')
    end
  end

  scenario 'Non-Authorized user tries to vote for answer', js: true do
    visit question_path(question)

    within '.answer-block' do
      expect(page).to_not have_text('vote up')
      expect(page).to_not have_text('vote down')
      expect(page).to_not have_text('vote cancel')
    end
  end
end
