module FeatureMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'submit'
  end

  def sign_out
    click_on 'Log out'
  end

  def mail_confirmation(email)
    fill_in 'email', with: email
    click_button 'submit'
  end

  def visit_user(user)
    login_as(user)
    visit question_path(question)
  end

  def visit_quest
    visit question_path(question)
  end
end
