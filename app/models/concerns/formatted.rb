module Formatted
  extend ActiveSupport::Concern

  def created_date
    created_at.strftime('%d/%m/%y %H:%M')
  end
end
