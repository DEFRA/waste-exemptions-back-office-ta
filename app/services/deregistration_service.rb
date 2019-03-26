# frozen_string_literal: true

class DeregistrationService

  attr_reader :registration_exemption

  def initialize(current_user, registration_exemption)
    @current_user = current_user
    @registration_exemption = registration_exemption
  end

  def deregister!(state_transition)
    return unless @current_user.can?(:deregister, @registration_exemption)

    # Apply the new state via the AASM helper method.
    @registration_exemption.public_send("#{state_transition}!")
  end
end
