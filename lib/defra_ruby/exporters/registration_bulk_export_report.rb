# frozen_string_literal: true

require "defra_ruby/exporters"

module DefraRuby
  module Exporters
    module RegistrationBulkExportReport
      COLUMNS = [
        { header: "reference_number", attribute: "registration.reference" },
        { header: "registration_date", attribute: "registered_on" },
        { header: "applicant_first_name", attribute: "registration.applicant_first_name" },
        { header: "applicant_last_name", attribute: "registration.applicant_last_name" },
        { header: "applicant_phone_number", attribute: "registration.applicant_phone" },
        { header: "applicant_email_address", attribute: "registration.applicant_email" },
        { header: "organisation_type", attribute: "registration.business_type" },
        { header: "company_reference_number", attribute: "registration.company_no" },
        { header: "organisation_name", attribute: "registration.operator_name" },
        { header: "organisation_premises", attribute: "registration.operator_address.premises" },
        { header: "organisation_street_address", attribute: "registration.operator_address.street_address" },
        { header: "organisation_locality", attribute: "registration.operator_address.locality" },
        { header: "organisation_city", attribute: "registration.operator_address.city" },
        { header: "organisation_postcode", attribute: "registration.operator_address.postcode" },
        { header: "correspondance_contact_first_name", attribute: "registration.contact_first_name" },
        { header: "correspondance_contact_last_name", attribute: "registration.contact_last_name" },
        { header: "correspondance_contact_position", attribute: "registration.contact_position" },
        { header: "correspondance_contact_email_address", attribute: "registration.contact_email" },
        { header: "correspondance_contact_phone_number", attribute: "registration.contact_phone" },
        { header: "correspondance_contact_premises", attribute: "registration.contact_address.premises" },
        { header: "correspondance_contact_street_address", attribute: "registration.contact_address.street_address" },
        { header: "correspondance_contact_locality", attribute: "registration.contact_address.locality" },
        { header: "correspondance_contact_city", attribute: "registration.contact_address.city" },
        { header: "correspondance_contact_postcode", attribute: "registration.contact_address.postcode" },
        { header: "on_a_farm?", attribute: "registration.on_a_farm" },
        { header: "is_a_farmer?", attribute: "registration.is_a_farmer" },
        { header: "site_premises", attribute: "registration.site_address.premises" },
        { header: "site_street_address", attribute: "registration.site_address.street_address" },
        { header: "site_locality", attribute: "registration.site_address.locality" },
        { header: "site_city", attribute: "registration.site_address.city" },
        { header: "site_postcode", attribute: "registration.site_address.postcode" },
        { header: "site_country", attribute: "registration.site_address.country_iso" },
        { header: "site_location_grid_reference", attribute: "registration.site_address.grid_reference" },
        { header: "site_location_description", attribute: "registration.site_address.description" },
        # TODO: Uncomment this when the column has been added to the DB
        # { header: "site_location_area", attribute: "registration.site_address.area" },
        { header: "exemption_code", attribute: "exemption.code" },
        { header: "exemption_summary", attribute: "exemption.summary" },
        { header: "exemption_status", attribute: "state" },
        { header: "exemption_valid_from_date", attribute: "registered_on" },
        { header: "exemption_expiry_date", attribute: "expires_on" },
        { header: "exemption_deregister_date", attribute: "deregistered_on" },
        { header: "exemption_deregister_comment", attribute: "deregistration_message" },
        { header: "assistance_type", attribute: "registration.assistance_mode" }
      ].freeze

      def self.columns
        COLUMNS
      end

      def self.query(filter = {})
        query = WasteExemptionsEngine::RegistrationExemption
                .joins(:exemption)
                .joins(registration: :addresses)
                .distinct
                .order(registered_on: :asc)

        query = query.where(registered_on: filter[:date_range]) if filter[:date_range].present?

        query
      end
    end
  end
end
