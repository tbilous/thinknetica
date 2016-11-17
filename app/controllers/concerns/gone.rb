module Gone
  extend ActiveSupport::Concern


  private

  def set_gon_current_user
    gon.current_user_id = current_user ? current_user.id : 0
  end

  # def gone_created_date
  #   gon.created_date
  # end
end
