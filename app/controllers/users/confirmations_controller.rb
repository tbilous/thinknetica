class Users::ConfirmationsController < Devise::ConfirmationsController

  protected

    def after_confirmation_path_for(resource_name, resource)
      if signed_in?(resource_name)
        signed_in_root_path(resource)
      else
        return user_twitter_omniauth_authorize_path if resource.need_email_confirmation?

        new_session_path(resource_name)
      end
    end
end
