require 'rails_helper'

feature 'user can login', %q{
  User can to register
  User can to Sign in
}do
  let!(:user_params) { FactoryGirl.attributes_for(:user) }
  scenario 'Sign Up ' do
    visit root_path
    click_on 'Reg'
    expect(page).to have_title t('page.registration')
    fill_in 'user_email', with: user_params[:email]
    fill_in 'user_name', with: user_params[:name]
    fill_in 'user_password', with: user_params[:password]
    fill_in 'user_password_confirmation', with: user_params[:password_confirmation]
    click_on t('devise.registrations.new.sign_up')
    expect(page).to have_title 'Home page'
  end
  scenario 'Sign In' do
    User.create!(email: user_params[:email], name: user_params[:name], password: user_params[:password])
    visit root_path
    click_on 'Sign'
    expect(page).to have_title t('page.sign_in')
    fill_in 'user_email', with: user_params[:email]
    fill_in 'user_password', with: user_params[:password]
    click_on t('devise.sessions.new.sign_in')
    expect(page).to have_title 'Home page'
  end
end