feature 'Vote question', %q{
  Authorized User can vote for question
  User can vote positive or negative only one time
  The Owner has not have rights for vote
} do
  
  let(:user)       { create(:user) }
  let(:owner)       { create(:user) }
  let(:question)   { create(:question, user: owner) }


  scenario 'User votes for the question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("question-vote-positive-#{question.id}")
    
    within "#question-vote-val-#{question.id}" do
      expect(page).to have_text('1')
    end

    click_on("question-vote-positive-#{question.id}")

    within "#question-vote-val-#{question.id}" do
      expect(page).to have_text('1')
    end

    click_on("question-vote-negative-#{question.id}")

    within "#question-vote-val-#{question.id}" do
      expect(page).to have_text('0')
    end

    click_on("question-vote-negative-#{question.id}")

    within "#question-vote-val-#{question.id}" do
      expect(page).to have_text('0')
    end

  end

  scenario 'Owner user tries to vote for question', js: true do
    pending "add some examples to (or delete) #{__FILE__}"
  end


  scenario 'Non-Authorized user tries to vote for question', js: true do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
