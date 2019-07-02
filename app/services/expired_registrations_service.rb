# frozen_string_literal: true

class ExpiredRegistrationsService < ::WasteExemptionsEngine::BaseService
  def run
    all_expired_registration_exemptions.each do |registration_exemption|
      registration_exemption.expire!
    end
  end

  private

  def all_expired_registration_exemptions
    WasteExemptionsEngine::RegistrationExemption.active.expired
  end
end
