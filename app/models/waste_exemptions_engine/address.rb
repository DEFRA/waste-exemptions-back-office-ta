# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "address")

module WasteExemptionsEngine
  class Address
    include WasteExemptionsEngine::CanBeSearchedLikeAddress
  end
end
