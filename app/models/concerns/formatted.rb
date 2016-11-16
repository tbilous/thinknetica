module Formatted
  extend ActiveSupport::Concern

  def created_date
    created_at.strftime('%m/%d/%Y %H:%M:%S')
  end
end
