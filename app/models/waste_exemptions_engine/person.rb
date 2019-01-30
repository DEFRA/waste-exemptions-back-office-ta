# frozen_string_literal: true

require_dependency WasteExemptionsEngine::Engine.config.root
                                                .join("app", "models", "waste_exemptions_engine", "person.rb")
                                                .to_s

module WasteExemptionsEngine
  class Person
    scope :search_for_name, lambda { |term|
      where("UPPER(CONCAT(first_name, ' ', last_name)) LIKE ?", "%#{term&.upcase}%")
    }
  end
end
