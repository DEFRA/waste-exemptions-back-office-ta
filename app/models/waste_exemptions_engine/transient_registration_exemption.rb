# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join(
  "app",
  "models",
  "waste_exemptions_engine",
  "transient_registration_exemption"
)

module WasteExemptionsEngine
  class TransientRegistrationExemption < ::WasteExemptionsEngine::ApplicationRecord
    include CanBeOrderedByStateAndExemptionId
  end
end
