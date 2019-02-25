# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "transient_person")

module WasteExemptionsEngine
  class TransientPerson
    include CanBeSearchedLikePerson
  end
end
