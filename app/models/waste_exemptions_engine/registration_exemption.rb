# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration_exemption")

module WasteExemptionsEngine
  class RegistrationExemption < ActiveRecord::Base
    include CanDeactivateExemption

    scope :order_by_state_then_exemption_id, lambda {
      order(
        "CASE
          WHEN state = 'active'  THEN '1'
          WHEN state = 'ceased'  THEN '2'
          WHEN state = 'revoked' THEN '3'
          WHEN state = 'expired' THEN '4'
        END",
        :exemption_id
      )
    }
  end
end
