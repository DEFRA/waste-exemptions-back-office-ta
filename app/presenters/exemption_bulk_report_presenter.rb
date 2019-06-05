# frozen_string_literal: true

class ExemptionBulkReportPresenter < BasePresenter
  def reference_number
    registration.reference
  end

  def registration_date
    registered_on.to_formatted_s(:year_month_day)
  end

  def applicant_full_name
    "#{registration.applicant_first_name} #{registration.applicant_last_name}"
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
    "#{registration.contact_first_name} #{registration.contact_last_name}"
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
    # TODO: Implement into the Registration model
    (registered_on + 3.years - 1.day).to_date.to_formatted_s(:year_month_day)
  end

  def exemption_deregister_date
    deregistered_at.to_formatted_s(:year_month_day)
  end

  def exemption_deregister_comment
    deregistration_message
  end

  def assistance_type
    registration.assistance_mode
  end

  def registration_detail_url
    # TODO: Use rails routes helpers
    "https://admin.wasteexemptions.service.gov.uk/admin/enrollments/#{registration.id}"
  end

  private

  def format_address(address)
    [
      address.organisation,
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
end
