module ApplicationHelper
  def bootstrap_class_for(flash_type)
    hash = HashWithIndifferentAccess.new(success: ' alert-success',
                                         error: ' alert-warning',
                                         alert: ' alert-danger',
                                         notice: ' alert-info')
    hash[flash_type] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in helper-class") do
        concat content_tag(:button, '×', class: 'close', data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end
end
