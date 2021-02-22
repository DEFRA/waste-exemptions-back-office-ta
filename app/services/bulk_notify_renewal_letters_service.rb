# frozen_string_literal: true

class BulkNotifyRenewalLettersService < ::WasteExemptionsEngine::BaseService
  def run(expires_on)
    @expires_on = expires_on

    ad_expiring_registrations.each do |registration|
      send_letter(registration)
    end

    ad_expiring_registrations
  end

  private

  def send_letter(registration)
    NotifyRenewalLetterService.run(registration: registration)
  rescue StandardError => e
    Airbrake.notify e
    Rails.logger.error "Bulk renewal letters error:\n#{e}"
  end

  def ad_expiring_registrations
    @_ad_expiring_registrations ||= lambda do
      WasteExemptionsEngine::Registration
        .order(:reference)
        .where(contact_email: WasteExemptionsEngine.configuration.assisted_digital_email)
        .where(
          id: WasteExemptionsEngine::RegistrationExemption
                .all_active_exemptions
                .where(expires_on: @expires_on)
                .select(:registration_id)
        )
    end.call
  end
end
