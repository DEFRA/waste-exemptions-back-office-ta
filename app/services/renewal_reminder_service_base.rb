# frozen_string_literal: true

class RenewalReminderServiceBase < ::WasteExemptionsEngine::BaseService
  def run
    expiring_registrations.each do |registration|
      begin
        send_email(registration)
      rescue StandardError => e
        Airbrake.notify e, registration: registration.reference
        Rails.logger.error "Failed to send first renewal email for registration #{registration.reference}"
      end
    end
  end

  private

  def send_email
    raise(NotImplementedError)
  end

  def expiring_registrations
    WasteExemptionsEngine::Registration.where(
      id: all_active_exemptions_registration_ids
    ).where("contact_email != 'waste-exemptions@environment-agency.gov.uk'")
  end

  def all_active_exemptions_registration_ids
    WasteExemptionsEngine::RegistrationExemption
      .all_active_exemptions
      .where(expires_on: expires_in_days.days.from_now.to_date)
      .pluck(:registration_id)
  end

  def expires_in_days
    raise(NotImplementedError)
  end
end
