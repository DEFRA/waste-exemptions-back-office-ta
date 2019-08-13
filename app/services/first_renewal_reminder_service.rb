# frozen_string_literal: true

class FirstRenewalReminderService < RenewalReminderServiceBase
  private

  def send_email(registration)
    if WasteExemptionsEngine::FeatureToggle.active?(:send_renewal_magic_link)
      RenewalReminderMailer.first_renew_with_magic_link_email(registration).deliver_now
    else
      RenewalReminderMailer.first_reminder_email(registration).deliver_now
    end
  end

  def expires_in_days
    WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
  end
end
