# frozen_string_literal: true

class DeregisterExemptionsForm
  include ActiveModel::Model

  attr_accessor :state_transition, :message

  def submit(params)
    self.state_transition = params[:state_transition]
    self.message = params[:message]&.strip
    valid?
  end

  def state_transition_options
    DeregistrationStateTransitionValidator::VALID_TRANSITIONS
  end

  validates :state_transition, "deregistration_state_transition": true
  validates :message, "deregistration_message": true
end
