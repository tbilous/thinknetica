class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  respond_to :json

  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with User.where.not(id: current_resource_owner.id)
  end

end
