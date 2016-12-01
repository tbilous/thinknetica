class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment = Attachment.find(params['id'])
    @attachment.destroy if current_user.owner_of?(@attachment.attachable)
  end
end
