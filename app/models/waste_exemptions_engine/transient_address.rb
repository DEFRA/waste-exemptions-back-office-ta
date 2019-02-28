# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "transient_address")

module WasteExemptionsEngine
  class TransientAddress
    include CanBeSearchedLikeAddress
  end
end
