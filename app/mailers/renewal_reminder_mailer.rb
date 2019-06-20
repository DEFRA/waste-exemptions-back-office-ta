# frozen_string_literal: true

class RenewalReminderMailer < ActionMailer::Base
  # So we can use displayable_address()
  include ::WasteExemptionsEngine::ApplicationHelper

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

  def reference(registration)
    registration.reference
  end

  def site_location(registration)
    address = registration.site_address

    if address.postcode.present?
      displayable_address(address).join(", ")
    else
      address.grid_reference
    end
  end

  def exemptions(registration)
    registration.exemptions.map { |ex| "#{ex.code} #{ex.summary}" }
  end
end
