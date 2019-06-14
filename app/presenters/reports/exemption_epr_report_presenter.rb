# frozen_string_literal: true

module Reports
  class ExemptionEprReportPresenter < BasePresenter
    def registration_number
      registration.reference
    end

    def organisation_name
      registration.operator_name
    end

    def organisation_premises
      registration.operator_address.premises
    end

    def organisation_street_address
      registration.operator_address.street_address
    end

    def organisation_locality
      registration.operator_address.locality
    end

    def organisation_city
      registration.operator_address.city
    end

    def organisation_postcode
      registration.operator_address.postcode
    end

    def site_premises
      registration.site_address.premises
    end

    def site_street_address
      registration.site_address.street_address
    end

    def site_locality
      registration.site_address.locality
    end

    def site_city
      registration.site_address.city
    end

    def site_postcode
      registration.site_address.postcode
    end

    def site_country
      registration.site_address.country_iso
    end

    def site_ngr
      registration.site_address.grid_reference
    end

    def site_easting
      registration.site_address.x
    end

    def site_northing
      registration.site_address.y
    end

    def exemption_code
      exemption.code
    end

    def exemption_registration_date
      registered_on.to_formatted_s(:year_month_day)
    end

    def exemption_expiry_date
      expires_on.to_formatted_s(:year_month_day)
    end
  end
end
