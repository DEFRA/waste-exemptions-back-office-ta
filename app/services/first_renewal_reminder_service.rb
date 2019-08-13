# frozen_string_literal: true

class FirstRenewalReminderService < RenewalReminderServiceBase
  private

  def send_email(registration)
    RenewalReminderMailer.first_reminder_email(registration).deliver_now
  end

  def expires_in_days
    WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
  end
end
