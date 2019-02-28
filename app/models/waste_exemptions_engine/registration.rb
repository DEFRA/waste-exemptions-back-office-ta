# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration")

module WasteExemptionsEngine
  class Registration
    include CanBeSearchedLikeRegistration

    scope :search_for_site_address_postcode, lambda { |term|
      joins(:addresses).merge(Address.search_for_postcode(term).site)
    }

    scope :search_for_person_name, lambda { |term|
      joins(:people).merge(Person.search_for_name(term))
    }
  end
end
