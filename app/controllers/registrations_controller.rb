# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def show
    find_resource(params[:id])
    authorize
  end

  private

  def find_resource(id)
    @resource = WasteExemptionsEngine::Registration.find(id)
  end

  def authorize
    authorize! :read, @resource
  end
end
