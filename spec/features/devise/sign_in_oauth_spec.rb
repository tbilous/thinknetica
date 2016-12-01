require 'acceptance_helper'
require 'shared_examples/features/omniauth_examples'

feature 'Signing in using oauth account', %q{
  In order to authorization over social account
  As User
  I want be able to sign in using my facebook account
  I want be able to sign in using my twitter account
  I want be able to sign in using my github account
 } do

  background { visit new_user_session_path }

  context 'User try to authorize with facebook' do
    it_behaves_like 'oauth authorization', 'facebook' do
      scenario 'Success authorization' do
        page.find('#oauthFacebook').click
        # save_and_open_page
        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end
    end
    context 'user already exist' do
      let!(:user) { create(:user, email: 'example@example.org') }
      it_behaves_like 'oauth authorization', 'facebook' do
        scenario 'Success authorization' do
          page.find('#oauthFacebook').click
          expect(page).to have_content 'Successfully authenticated from Facebook account'
        end
      end
    end
  end

  context 'User try to authorize with twitter' do
    it_behaves_like 'oauth authorization', 'twitter' do
      scenario 'Success authorization' do
        clear_emails
        page.find('#oauthTwitter').click

        mail_confirmation('test@example.com')

        expect(page).to have_content t('devise.registrations.user.send_instructions')

        open_email('test@example.com')

        current_email.click_link 'Confirm my account'

        expect(page).to have_content t('devise.confirmations.confirmed')

        visit new_user_session_path

        page.find('#oauthTwitter').click

        expect(page).to have_content 'Successfully authenticated from Twitter account'
      end
    end
  end

  context 'User try to authorize with github' do
    it_behaves_like 'oauth authorization', 'github' do
      scenario 'Success authorization' do
        clear_emails
        page.find('#oauthGithub').click

        mail_confirmation('test@example.com')

        expect(page).to have_content t('devise.registrations.user.send_instructions')

        open_email('test@example.com')

        current_email.click_link 'Confirm my account'

        expect(page).to have_content t('devise.confirmations.confirmed')

        visit new_user_session_path

        page.find('#oauthGithub').click

        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end
  end
end
