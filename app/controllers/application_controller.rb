require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :debug_locale if Rails.env.test? || Rails.env.development?
  before_action :gon_user, unless: :devise_controller?

  def set_locale
    I18n.locale = (extract_locale_header == ('uk' || 'ru') ? 'ru' : 'en')
  end

  def debug_locale
    logger.debug "*!!! Browser locale is '#{extract_locale_header}'"
    logger.debug "*!!! Browser full header '#{extract_full_header}'"
    logger.debug "*!!! Locale set to '#{I18n.locale}'"
  end

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
    request.referrer
    scope_path = root_path
    respond_to?(scope_path, true) ? send(scope_path) : root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: { error: 'You are not authorized to perform requested action' }.to_json,
                           status: :forbidden }
      format.js   { head :forbidden }
    end
  end

  private

  def gon_user
    gon.current_user_id = current_user ? current_user.id : 0
  end

  def extract_full_header
    request.env['HTTP_ACCEPT_LANGUAGE'].to_s
  end

  def extract_locale_header
    request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
