# frozen_string_literal: true

class DeregisterExemptionsController < ApplicationController
  def new
    find_resource(params[:id])
    @deregister_exemptions_form ||= DeregisterExemptionsForm.new

    handle_permission_denied unless DeregistrationService.new(current_user, @resource).deregistration_allowed?
  end

  def update
    find_resource(params[:id])
    @deregister_exemptions_form ||= DeregisterExemptionsForm.new

    deregistration_service = DeregistrationService.new(current_user, @resource)

    return handle_permission_denied unless deregistration_service.deregistration_allowed?

    if @deregister_exemptions_form.submit(params[:deregister_exemptions_form], deregistration_service)
      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_path(reference: @resource.registration.reference), status: successful_redirection
    else
      render :new
      false
    end
  end

  private

  def find_resource(id)
    @resource = WasteExemptionsEngine::RegistrationExemption.find(id)
  end

  def handle_permission_denied
    unsuccessful_redirection = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE
    redirect_to "/pages/permission", status: unsuccessful_redirection
  end
end
