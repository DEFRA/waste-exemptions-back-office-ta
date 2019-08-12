# frozen_string_literal: true

class SecondRenewalReminderService < RenewalReminderServiceBase
  private

  def send_email(registration)
    RenewalReminderMailer.second_reminder_email(registration).deliver_now
  end

  def expires_in_days
    WasteExemptionsBackOffice::Application.config.second_renewal_email_reminder_days.to_i
  end

  def default_scope
    super.where.not(id: recent_renewals_ids)
  end

  def recent_renewals_ids
    WasteExemptionsEngine::Registration
      .renewals
      .where(submitted_at: 1.month.ago..Time.now)
      .pluck(:referring_registration_id)
  end
end
