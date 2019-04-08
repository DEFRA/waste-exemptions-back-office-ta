# frozen_string_literal: true

require "defra_ruby/exporters"

module DefraRuby
  module Exporters
    module RegistrationEprExportReport
      COLUMNS = [
        { header: "registration_number", attribute: "registration.reference" },
        { header: "organisation_name", attribute: "registration.operator_name" },
        { header: "organisation_premises", attribute: "registration.operator_address.premises" },
        { header: "organisation_street_address", attribute: "registration.operator_address.street_address" },
        { header: "organisation_locality", attribute: "registration.operator_address.locality" },
        { header: "organisation_city", attribute: "registration.operator_address.city" },
        { header: "organisation_postcode", attribute: "registration.operator_address.postcode" },
        { header: "site_premises", attribute: "registration.site_address.premises" },
        { header: "site_street_address", attribute: "registration.site_address.street_address" },
        { header: "site_locality", attribute: "registration.site_address.locality" },
        { header: "site_city", attribute: "registration.site_address.city" },
        { header: "site_postcode", attribute: "registration.site_address.postcode" },
        { header: "site_country", attribute: "registration.site_address.country_iso" },
        { header: "site_ngr", attribute: "registration.site_address.grid_reference" },
        { header: "site_easting", attribute: "registration.site_address.x" },
        { header: "site_northing", attribute: "registration.site_address.y" },
        { header: "exemption_code", attribute: "exemption.code" },
        { header: "exemption_registration_date", attribute: "registered_on" },
        { header: "exemption_expiry_date", attribute: "expires_on" }
      ].freeze

      def self.columns
        COLUMNS
      end

      def self.query
        WasteExemptionsEngine::RegistrationExemption
          .joins(:exemption)
          .joins(registration: :addresses)
          .where(state: :active)
          .where("expires_on > ?", DateTime.now)
          .distinct
      end
    end
  end
end
