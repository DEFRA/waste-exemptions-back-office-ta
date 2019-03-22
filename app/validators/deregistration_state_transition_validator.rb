# frozen_string_literal: true

class DeregistrationStateTransitionValidator < WasteExemptionsEngine::BaseValidator
  include WasteExemptionsEngine::CanValidatePresence
  include WasteExemptionsEngine::CanValidateSelection

  VALID_TRANSITIONS = %w[revoke cease].freeze

  def validate_each(record, attribute, value)
    return false unless value_is_present?(record, attribute, value)

    value_is_included?(record, attribute, value, VALID_TRANSITIONS)
  end
end
