# frozen_string_literal: true

module Data
  class MonthlyBulkSerializer < BaseSerializer
    ATTRIBUTES = %i[
      reference_number
      registration_date
      applicant_full_name
      applicant_phone_number
      applicant_email_address
      organisation_type
      company_reference_number
      organisation_name
      organisation_address
      correspondance_contact_full_name
      correspondance_contact_position
      correspondance_contact_address
      correspondance_contact_email_address
      on_a_farm?
      is_a_farmer?
      site_location_address
      site_location_grid_reference
      site_location_description
      site_location_area
      exemption_code
      exemption_summary
      exemption_status
      exemption_valid_from_date
      exemption_expiry_date
      exemption_deregister_date
      exemption_deregister_comment
      assistance_type
      registration_detail_url
    ].freeze

    def initialize(first_day_of_the_month)
      @first_day_of_the_month = first_day_of_the_month
    end

    private

    attr_reader :first_day_of_the_month

    def registration_exemptions_scope
      WasteExemptionsEngine::RegistrationExemption.data_for_month(first_day_of_the_month)
    end

    def parse_registration_exemption(registration_exemption)
      ATTRIBUTES.map do |attribute|
        presenter = ExemptionBulkReportPresenter.new(registration_exemption)
        presenter.public_send(attribute)
      end
    end
  end
end
