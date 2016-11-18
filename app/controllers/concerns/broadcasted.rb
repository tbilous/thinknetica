module Broadcasted
  extend ActiveSupport::Concern

  included do
    after_action :broadcasted, only: :create
  end

  def publish_broadcast(item, target = controller_name.singularize )
    return if item.errors.any?
    item.has_attribute?('commentable_type') ? broadcast_comment(item, target) : broadcast_answer(item, target)
  end

  def broadcast_comment(item, target)
    ActionCable.server.broadcast "#{target}_#{item.root_question_id}", "#{target}": item, message: t('.message')
  end

  def broadcast_answer(item, target)
    ActionCable.server.broadcast "#{target}_#{item.question_id}", "#{target}": item, message: t('.message')
  end

end
