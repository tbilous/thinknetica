class CommentsController < ApplicationController

  before_action :load_comment, only: :destroy
  before_action :require_permission, only: :destroy

  def destroy
    @comment.destroy
  end

  private

  def load_comment
    @comment = Comment.find(params['id'])
  end

  def require_permission
    redirect_to root_path, alert: 'NO RIGHTS!' unless current_user && current_user.owner_of?(@comment)
  end
end
