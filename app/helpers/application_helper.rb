module ApplicationHelper
  def full_title(page_title)
    base_title = 'Thinknetica'
    if page_title.empty?
      base_title
    else
      "#{base_title} #{page_title}"
    end
  end

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

  def shallow_resource(*args)
    if args.last.persisted?
      args.last
    else
      args
    end
  end

  def render_flash
    javascript_tag("App.flash = JSON.parse(" "'#{j({ success: flash.notice, error: flash.alert }.to_json)}'" ");")
  end

  def render_errors_for(resource)
    return unless resource.errors.any?
    flash.now.alert = resource.errors.full_messages.join(", ")
  end
end
