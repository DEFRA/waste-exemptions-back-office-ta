# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration_Exemption")

module WasteExemptionsEngine
  class RegistrationExemption
    include CanDeactivateExemption
  end
end
