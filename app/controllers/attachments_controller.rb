class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params['id'])
    if current_user.owner_of?(@attachment.attachable)
      @attachment.destroy
    end
  end
end
