class Users::RegistrationsController < Devise::RegistrationsController
  before_action :get_user, only: [:edit_email, :update_email]

  def edit_email; end


  def update_email
    if @user && @user.update(email: params['email'])
      redirect_to root_path
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
    else
      render 'edit_email'
    end
  end

  def get_user
    @user = User.find(session['devise.new_user_id'])
  end
end
