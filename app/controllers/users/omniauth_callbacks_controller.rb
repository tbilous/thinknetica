class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_authorization

  def facebook; end

  def twitter; end

  def github; end

  private

  def oauth_authorization
    @oauth = request.env['omniauth.auth']
    @user = User.find_for_oauth(@oauth)

    if @user && @user.persisted?
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: @oauth.provider.capitalize) if is_navigational_format?
      else
        session['devise.new_user_id'] = @user.id
        redirect_to edit_signup_email_path
      end
    else
      flash[:alert] = 'No have data!'
    end
  end
end
