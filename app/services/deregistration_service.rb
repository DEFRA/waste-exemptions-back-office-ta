# frozen_string_literal: true

class DeregistrationService
  ALLOWED_ROLES = %w[system super_agent].freeze

  def initialize(current_user, registration_exemption)
    @current_user = current_user
    @registration_exemption = registration_exemption
  end

  def deregistration_allowed?
    @registration_exemption.active? && ALLOWED_ROLES.include?(@current_user.role)
  end

  def deregister!(state_transition)
    return unless deregistration_allowed?

    # Apply the new state via the AASM helper method.
    @registration_exemption.public_send("#{state_transition}!")
  end
end
