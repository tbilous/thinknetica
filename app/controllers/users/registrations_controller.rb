class Users::RegistrationsController < Devise::RegistrationsController
  before_action :load_oauth_user, only: [:edit_email, :update_email]

  def edit_email; end


  def update_email
    if @user && @user.update(email: params['email'])
      redirect_to root_path
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
    else
      render 'edit_email'
    end
  end

  def load_oauth_user
    @user = User.find(session['devise.new_user_id'])
  end
end
