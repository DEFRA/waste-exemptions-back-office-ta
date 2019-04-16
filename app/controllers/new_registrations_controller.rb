# frozen_string_literal: true

class NewRegistrationsController < ApplicationController
  helper ActionLinksHelper
  helper RegistrationsHelper

  def show
    find_resource(params[:reference])
    authorize
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::NewRegistration.find_by(reference: reference)
  end

  def authorize
    authorize! :read, @resource
  end
end
