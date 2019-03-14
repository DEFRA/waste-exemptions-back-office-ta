# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def show
    find_resource(params[:reference])
    authorize
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def authorize
    authorize! :read, @resource
  end
end
