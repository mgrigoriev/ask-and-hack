require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { error: 'You are not authorized to perform requested action' }.to_json, status: :forbidden }
      format.js   { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
