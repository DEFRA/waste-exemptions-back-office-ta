# frozen_string_literal: true

class DeregistrationService

  attr_reader :resource

  def initialize(current_user, resource)
    @current_user = current_user
    @resource = resource
  end

  def deregister!(state_transition, deregistration_message)
    return unless @current_user.can?(:deregister, @resource)

    if @resource.is_a?(WasteExemptionsEngine::Registration)
      @resource.registration_exemptions.each do |re|
        DeregistrationService.new(@current_user, re).deregister!(state_transition, deregistration_message)
      end
    else
      # Apply the new state via the AASM helper method.
      @resource.public_send("#{state_transition}!")
      @resource.update_attributes(deregistration_message: deregistration_message)
    end
  end
end
