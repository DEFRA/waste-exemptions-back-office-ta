# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module Reports
  class ExemptionBulkReportPresenter < BasePresenter
    def reference_number
      registration.reference
    end

    def registration_date
      registered_on.to_formatted_s(:year_month_day)
    end

    def applicant_full_name
      format_name(registration.applicant_first_name, registration.applicant_last_name)
    end

    def applicant_phone_number
      registration.applicant_phone
    end

    def applicant_email_address
      registration.applicant_email
    end

    def organisation_type
      registration.business_type
    end

    def company_reference_number
      registration.company_no
    end

    def organisation_name
      registration.operator_name
    end

    def organisation_address
      format_address(registration.operator_address)
    end

    def correspondance_contact_full_name
      format_name(registration.contact_first_name, registration.contact_last_name)
    end

    def correspondance_contact_position
      registration.contact_position
    end

    def correspondance_contact_address
      format_address(registration.contact_address)
    end

    def correspondance_contact_email_address
      registration.contact_email
    end

    def on_a_farm?
      registration.on_a_farm? ? "yes" : "no"
    end

    # rubocop:disable Naming/PredicateName
    def is_a_farmer?
      registration.is_a_farmer? ? "yes" : "no"
    end
    # rubocop:enable Naming/PredicateName

    def site_location_address
      return if site_address.located_by_grid_reference?

      format_address(site_address)
    end

    def site_location_grid_reference
      site_address.grid_reference
    end

    def site_location_description
      site_address.description
    end

    def site_location_area
      site_address.area
    end

    def exemption_code
      exemption.code
    end

    def exemption_summary
      exemption.summary
    end

    def exemption_status
      state
    end

    def exemption_valid_from_date
      registration_date
    end

    def exemption_expiry_date
      expires_on&.to_date&.to_formatted_s(:year_month_day)
    end

    def exemption_deregister_date
      deregistered_at&.to_formatted_s(:year_month_day)
    end

    def exemption_deregister_comment
      deregistration_message
    end

    def assistance_type
      registration.assistance_mode
    end

    def registration_detail_url
      Rails.application.routes.url_helpers.registration_url(
        reference: registration.reference,
        host: back_office_host
      )
    end

    private

    def format_name(first_name, last_name)
      "#{first_name} #{last_name}"
    end

    def format_address(address)
      [
        address.premises,
        address.street_address,
        address.locality,
        address.city,
        address.postcode
      ].join(", ")
    end

    def site_address
      @_site_address ||= registration.site_address
    end

    def back_office_host
      WasteExemptionsBackOffice::Application.config.back_office_url
    end
  end
end
# rubocop:enable Metrics/ClassLength
