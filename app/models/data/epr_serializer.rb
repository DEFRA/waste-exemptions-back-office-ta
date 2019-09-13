# frozen_string_literal: true

module Data
  class EprSerializer < BaseSerializer
    ATTRIBUTES = %i[
      registration_number
      organisation_name
      organisation_premises
      organisation_street_address
      organisation_locality
      organisation_city
      organisation_postcode
      site_premises
      site_street_address
      site_locality
      site_city
      site_postcode
      site_country
      site_ngr
      site_easting
      site_northing
      exemption_code
      exemption_registration_date
      exemption_expiry_date
    ].freeze

    private

    attr_reader :first_day_of_the_month

    def registration_exemptions_scope
      WasteExemptionsEngine::RegistrationExemption.all_active_exemptions
    end

    def parse_registration_exemption(registration_exemption)
      ATTRIBUTES.map do |attribute|
        presenter = ExemptionEprReportPresenter.new(registration_exemption)
        presenter.public_send(attribute)
      end
    end
  end
end
