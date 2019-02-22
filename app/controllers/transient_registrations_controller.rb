# frozen_string_literal: true

class TransientRegistrationsController < ApplicationController
  def show
    find_resource(params[:id])
  end

  private

  def find_resource(id)
    @resource = WasteExemptionsEngine::TransientRegistration.find(id)
  end
end
