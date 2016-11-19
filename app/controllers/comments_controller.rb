class CommentsController < ApplicationController
  include Contexted
  include Serialized
  include Broadcasted

  before_action :authenticate_user!
  before_action :set_context, only: [:create]
  before_action :load_comment, only: :destroy
  before_action :require_permission, only: :destroy

  def create
    @comment = @context.comments.create(
      strong_params.merge(user: current_user)
    )
    # render_json @comment
    if @comment.save
      render_json @comment
    else
      render_errors @comment
    end
  end

  def destroy
    @comment.destroy
    # flash[:success] = 'NICE' if @comment.destroy
    if @comment.destroy
      render_json @comment
    else
      render_errors @comment
    end
  end

  private

  def strong_params
    params.require(:comment).permit(:body)
  end

  def broadcasted
    publish_broadcast @comment
  end

  def load_comment
    @comment = Comment.find(params['id'])
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' unless current_user && current_user.owner_of?(@comment)
  end
end
