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
    WasteExemptionsBackOffice::Application.config.first_renewal_email_reminder_days.to_i
  end
end
