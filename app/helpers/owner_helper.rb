module OwnerHelper
  def help_owner?(object)
    return nil if current_user.nil? || !object.respond_to?(:user_id)
    current_user.try(:id) == object.try(:user_id)
  end
end
