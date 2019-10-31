# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration")

module WasteExemptionsEngine
  class Registration < ActiveRecord::Base
    include CanBeSearchedLikeRegistration

    NCCC_EMAIL = "waste-exemptions@environment-agency.gov.uk"

    scope :search_for_site_address_postcode, lambda { |term|
      joins(:addresses).merge(Address.search_for_postcode(term).site)
    }

    scope :search_for_person_name, lambda { |term|
      joins(:people).merge(Person.search_for_name(term))
    }

    scope :renewals, -> { where.not(referring_registration_id: nil) }

    scope :contact_email_is_not_nccc, -> { where.not(contact_email: NCCC_EMAIL) }

    scope :site_address_is_not_nccc, lambda {
      joins(:addresses).merge(Address.site.not_nccc)
    }

    def active?
      state == "active"
    end

    def expired?
      state == "expired"
    end

    def state
      raise "A Registration must have at least one RegistrationExemption." if registration_exemptions.empty?

      return "active" if registration_exemptions.select(&:active?).any?
      return "revoked" if registration_exemptions.select(&:revoked?).any?
      return "expired" if registration_exemptions.select(&:expired?).any?

      "ceased"
    end

    def renewable?
      in_renewal_window? && in_renewable_state?
    end

    def in_renewable_state?
      active? || expired?
    end
  end
end
