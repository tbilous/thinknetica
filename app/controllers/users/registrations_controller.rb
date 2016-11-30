class Users::RegistrationsController < Devise::RegistrationsController

  def edit_email
  end

  def update_email
    @user = User.find(session['devise.new_user_id'])

    if @user && @user.update(email: params['email'])
      redirect_to root_path
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
    else
      render 'edit_email'
    end
  end
end
