feature 'Vote answer', %q{
  Authorized User can vote for answer
  User can vote positive or negative only one time
  The Owner has not have rights for vote
} do
  
  let(:user)       { create(:user) }
  let(:owner)      { create(:user) }
  let(:question)   { create(:question, user: owner) }
  let!(:answer)    { create(:answer, question: question, user: owner) }

  scenario 'User votes for the answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("answer-vote-positive-#{answer.id}")
    
    within "#answer-vote-val-#{answer.id}" do
      expect(page).to have_text('1')
    end

    click_on("answer-vote-positive-#{answer.id}")

    within "#answer-vote-val-#{answer.id}" do
      expect(page).to have_text('1')
    end

    click_on("answer-vote-negative-#{answer.id}")

    within "#answer-vote-val-#{answer.id}" do
      expect(page).to have_text('0')
    end

    click_on("answer-vote-negative-#{answer.id}")

    within "#answer-vote-val-#{answer.id}" do
      expect(page).to have_text('0')
    end


  end

  scenario 'Owner user tries to vote for answer', js: true do
    sign_in(owner)
    visit question_path(question)


  end


  scenario 'Non-Authorized user tries to vote for answer', js: true do
    visit question_path(question)


  end
end
