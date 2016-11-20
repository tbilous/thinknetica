module Broadcasted
  extend ActiveSupport::Concern

  included do
    after_action :broadcasted, only: [:create, :destroy]
  end

  def publish_broadcast(item, target = controller_name.singularize, action = action_name)
    return if item.errors.any?
    target == 'comment' ? broadcast_comment(item, target, action) : broadcast_answer(item, target, action)
  end

  def broadcast_comment(item, target, action)

    data = {id: item.id,
            body: item.body,
            commentable_type: item.commentable_type,
            commentable_id: item.commentable_id,
            user_id: item.user_id,
            date: item.created_date
    }

    ActionCable.server.broadcast "#{target}_#{item.root_question_id}",
                                 "#{target}": data, message: t('.message'), action: action
  end

  def broadcast_answer(item, target, action)

    attached = []
    item.attachments.each { |a| attached <<
      { id: a.id, file_url: a.file.url, file_name: a.file.identifier } } if item.attachments.present?

    data = {id: item.id,
            body: item.body,
            files: attached,
            question_id: item.question_id,
            question_user_id: item.question.user_id,
            user_id: item.user_id,
            best: item.best,
            date: item.created_date
    }

    ActionCable.server.broadcast "#{target}_#{item.question_id}",
                                 "#{target}": data, message: t('.message'), action: action
  end
end
