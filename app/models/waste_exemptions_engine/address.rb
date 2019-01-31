# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "address")

module WasteExemptionsEngine
  class Address
    scope :search_for_postcode, lambda { |term|
      where("UPPER(postcode) LIKE ?", "%#{term&.upcase}%")
    }

    scope :site, -> { where(address_type: 3) }
  end
end
