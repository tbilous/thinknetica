class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_oauth, only: :facebook

  def facebook
    @user = User.find_for_oauth(@oauth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @oauth.provider.capitalize) if is_navigational_format?
    end
  end

  def set_oauth
    @oauth = request.env['omniauth.auth']
  end

  private
end
