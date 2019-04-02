# frozen_string_literal: true

class DeregisterRegistrationsController < DeregisterExemptionsController

  protected

  def find_resource(id)
    @resource = WasteExemptionsEngine::Registration.find(id)
  end

  def registration_reference
    @resource.reference
  end
end
