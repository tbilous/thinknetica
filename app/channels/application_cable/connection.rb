module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect; end

    # def disconnect(data)
    #   Rails.logger.into data
    # end
  end
end
