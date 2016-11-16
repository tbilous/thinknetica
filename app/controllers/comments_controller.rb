class CommentsController < ApplicationController
  include Contexted
  include Serialized

  before_action :authenticate_user!
  before_action :set_context, only: [:create]
  before_action :load_comment, only: :destroy
  before_action :require_permission, only: :destroy
  # after_action :publish_comment, only: :create

  def create
    @comment = @context.comments.create(
      strong_params.merge(user: current_user)
    )
    render_json @comment
  end

  def destroy
    @comment.destroy
    flash[:success] = 'NICE' if @comment.destroy
  end

  private

  def strong_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast('comments',
      {
        comment: ApplicationController.render(
          locals: { comment: @comment },
          partial: 'comments/comment'
        )
      }
    )
  end

  def load_comment
    @comment = Comment.find(params['id'])
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' unless current_user && current_user.owner_of?(@comment)
  end
end
