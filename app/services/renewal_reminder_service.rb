# frozen_string_literal: true

class RenewalReminderService < ::WasteExemptionsEngine::BaseService
  def run
    expiring_registrations.each do |registration|
      RenewalReminderMailer.first_reminder_email(registration).deliver_now
    end
  end

  private

  def expiring_registrations
    WasteExemptionsEngine::Registration.where(id:
      WasteExemptionsEngine::RegistrationExemption
        .all_active_exemptions
        .where(expires_on: 4.weeks.from_now.to_date)
        .pluck(:registration_id)
    )
  end
end
