# frozen_string_literal: true

class FirstRenewalReminderService < RenewalReminderServiceBase
  private

  def send_email(registration)
    FirstRenewalReminderEmailService.run(registration: registration)
  end

  def expires_in_days
    WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
  end
end
