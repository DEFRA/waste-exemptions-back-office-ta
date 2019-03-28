# frozen_string_literal: true

module Helpers
  module Registrations
    STANDARD_EXPIRATION = WasteExemptionsEngine.configuration.years_before_expiry.years

    def self.activate(registration, registration_date = Date.today)
      registration.registration_exemptions.each do |registration_exemption|
        registration_exemption.state = "active"
        registration_exemption.registered_on = registration_date
        registration_exemption.expires_on = registration_date + (STANDARD_EXPIRATION - 1.day)
        registration_exemption.save!
      end
    end

    def self.cease(registration)
      registration.registration_exemptions.each do |registration_exemption|
        registration_exemption.state = "ceased"
        registration_exemption.save!
      end
    end

    def self.expire(registration)
      registration.registration_exemptions.each do |registration_exemption|
        expiry_date = Date.today - 1.day
        registration_exemption.state = "expired"
        registration_exemption.expires_on = expiry_date
        registration_exemption.registered_on = expiry_date - STANDARD_EXPIRATION
        registration_exemption.save!
      end
    end
  end
end
