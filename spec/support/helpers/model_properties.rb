# frozen_string_literal: true

module Helpers
  module ModelProperties
    REGISTRATION = %i[
      reference
      location
      applicant_first_name
      applicant_last_name
      applicant_phone
      applicant_email
      business_type
      operator_name
      company_no
      contact_first_name
      contact_last_name
      contact_position
      contact_phone
      contact_email
      on_a_farm
      is_a_farmer
      submitted_at
      assistance_mode
    ].freeze

    TRANSIENT_REGISTRATION = (REGISTRATION + %i[
      token
      workflow_state
      start_option
      declaration
      temp_operator_postcode
      temp_contact_postcode
      temp_site_postcode
      temp_grid_reference
      temp_site_description
      address_finder_error
      type
    ]).freeze

    EDITED_REGISTRATION_UNCOPYABLE = (TRANSIENT_REGISTRATION - %i[
      address_finder_error
      type
      workflow_state
    ]).freeze
  end
end
