# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration")

module WasteExemptionsEngine
  class Registration < ActiveRecord::Base
    include CanBeSearchedLikeRegistration

    scope :search_for_site_address_postcode, lambda { |term|
      joins(:addresses).merge(Address.search_for_postcode(term).site)
    }

    scope :search_for_person_name, lambda { |term|
      joins(:people).merge(Person.search_for_name(term))
    }

    def active?
      state == "active"
    end

    def state
      raise "A Registration must have at least one RegistrationExemption." if registration_exemptions.empty?

      return "active" if registration_exemptions.select(&:active?).any?
      return "revoked" if registration_exemptions.select(&:revoked?).any?
      return "expired" if registration_exemptions.select(&:expired?).any?

      "ceased"
    end
  end
end
