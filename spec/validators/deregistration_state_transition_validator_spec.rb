# frozen_string_literal: true

require "rails_helper"

module Test
  DeregistrationStateTransitionValidatable = Struct.new(:state_transition) do
    include ActiveModel::Validations

    validates :state_transition, "deregistration_state_transition": true
  end
end

module WasteExemptionsEngine
  RSpec.describe DeregistrationStateTransitionValidator, type: :model do
    valid_transition = %w[revoke cease].sample

    it_behaves_like "a validator", Test::DeregistrationStateTransitionValidatable, :state_transition, valid_transition
    it_behaves_like "a selection validator", Test::DeregistrationStateTransitionValidatable, :state_transition
  end
end
