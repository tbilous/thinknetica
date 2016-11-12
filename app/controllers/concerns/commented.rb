module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: :comment_index
    before_action :set_commentable, only: [:comment_create]
  end

  def comment_create
    @comment = @commentable.comments.create(
        comment_params.merge(user: current_user)
    )
    render_json @comment
  end

  def comment_index
    @comments = @commentable.comments
  end

  protected
  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.permit(:body)
  end

end