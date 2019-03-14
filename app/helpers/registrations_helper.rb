# frozen_string_literal: true

module RegistrationsHelper
  def applicant_data_present?(resource)
    [resource.applicant_first_name,
     resource.applicant_last_name,
     resource.applicant_phone,
     resource.applicant_email].any?
  end

  def contact_data_present?(resource)
    [resource.contact_first_name,
     resource.contact_last_name,
     resource.contact_phone,
     resource.contact_email,
     resource.contact_position].any?
  end
end
