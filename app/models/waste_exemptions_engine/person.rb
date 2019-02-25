# frozen_string_literal: true

require_dependency WasteExemptionsEngine::Engine.config.root
                                                .join("app", "models", "waste_exemptions_engine", "person.rb")
                                                .to_s

module WasteExemptionsEngine
  class Person
    include CanBeSearchedLikePerson
  end
end
