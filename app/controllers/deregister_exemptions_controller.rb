# frozen_string_literal: true

class DeregisterExemptionsController < ApplicationController
  def new
    setup_form
  end

  def update
    setup_form
    deregistration_service = DeregistrationService.new(current_user, @resource)

    if @deregister_exemptions_form.submit(params[:deregister_exemptions_form], deregistration_service)
      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_path(reference: @resource.registration.reference), status: successful_redirection
    else
      render :new
      false
    end
  end

  private

  def setup_form
    find_resource(params[:id])
    @deregister_exemptions_form ||= DeregisterExemptionsForm.new
    authorize! :deregister, @resource
  end

  def find_resource(id)
    @resource = WasteExemptionsEngine::RegistrationExemption.find(id)
  end
end
