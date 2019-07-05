# frozen_string_literal: true

class ExpiredRegistrationsService < ::WasteExemptionsEngine::BaseService
  def run
    all_expired_registration_exemptions.each(&:expire!)
  end

  private

  def all_expired_registration_exemptions
    WasteExemptionsEngine::RegistrationExemption.active.expired_by_date
  end
end
