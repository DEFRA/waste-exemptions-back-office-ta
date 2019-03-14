# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_and_authorize_active_user
  before_action :back_button_cache_buster
  before_action :set_paper_trail_whodunnit

  helper WasteExemptionsEngine::ApplicationHelper

  rescue_from CanCan::AccessDenied do
    redirect_to "/pages/permission"
  end

  def authenticate_and_authorize_active_user
    return if skip_auth_on_this_controller?

    authenticate_user!

    if current_user_cannot_use_back_office?
      redirect_to "/pages/deactivated"
      return
    end

    authorize_engine_access
  end

  # http://jacopretorius.net/2014/01/force-page-to-reload-on-browser-back-in-rails.html
  def back_button_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  private

  def skip_auth_on_this_controller?
    # Don't authorize and authenticate pages from HighVoltage or Devise
    # Normally we'd use a skip_before_action, but these controllers are in gems
    controller = params[:controller]
    controller.include?("pages") || controller.include?("devise")
  end

  def current_user_cannot_use_back_office?
    # Don't try to check user permissions if the user isn't logged in
    return false if current_user.blank?

    cannot? :use_back_office, :all
  end

  def authorize_engine_access
    controller = params[:controller]
    return unless controller.include?("waste_exemptions_engine")

    authorize! :create, WasteExemptionsEngine::Registration.new
  end
end
