# frozen_string_literal: true

class RenewalReminderMailer < ActionMailer::Base
  def first_reminder_email(registration)
    @contact_name = contact_name(registration)
    @expiry_date = expiry_date(registration)
    @reference = reference(registration)
    @site_location = site_location(registration)
    @exemptions = exemptions(registration)

    mail(
      to: registration.contact_email,
      from: from_email,
      subject: I18n.t(".renewal_reminder_mailer.first_reminder_email.subject")
    )
  end

  private

  def from_email
    config = WasteExemptionsEngine.configuration
    "#{config.service_name} <#{config.email_service_email}>"
  end

  def contact_name(registration)
    "#{registration.contact_first_name} #{registration.contact_last_name}"
  end

  def expiry_date(_registration)
    "TODO"
  end

  def reference(_registration)
    "TODO"
  end

  def site_location(_registration)
    "TODO"
  end

  def exemptions(_registration)
    ["TODO"]
  end
end
