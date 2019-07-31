# frozen_string_literal: true

class RenewalReminderMailer < ActionMailer::Base
  # So we can use displayable_address()
  include ::WasteExemptionsEngine::ApplicationHelper
  add_template_helper(MailerHelper)

  def first_reminder_email(registration)
    assign_values_for_email(registration)

    mail(
      to: registration.contact_email,
      from: from_email,
      subject: I18n.t(".renewal_reminder_mailer.first_reminder_email.subject")
    )
  end

  def first_renew_with_magic_link_email(registration)
    assign_values_for_email(registration)

    mail(
      to: registration.contact_email,
      from: from_email,
      subject: I18n.t(".renewal_reminder_mailer.first_renew_with_magic_link_email.subject", date: @expiry_date)
    )
  end

  private

  def assign_values_for_email(registration)
    @contact_name = contact_name(registration)
    @expiry_date = expiry_date(registration)
    @reference = reference(registration)
    @site_location = site_location(registration)
    @exemptions = exemptions(registration)
  end

  def from_email
    config = WasteExemptionsEngine.configuration
    "#{config.service_name} <#{config.email_service_email}>"
  end

  def contact_name(registration)
    "#{registration.contact_first_name} #{registration.contact_last_name}"
  end

  def expiry_date(registration)
    # Currently you can only add exemptions when you register, so we can assume they expire at the same time
    registration.registration_exemptions.first.expires_on.to_formatted_s(:day_month_year)
  end

  def reference(registration)
    registration.reference
  end

  def site_location(registration)
    address = registration.site_address

    if address.located_by_grid_reference?
      address.grid_reference
    else
      displayable_address(address).join(", ")
    end
  end

  def exemptions(registration)
    active_exemptions = registration.registration_exemptions.select(&:may_expire?)
    active_exemptions.map { |ex| "#{ex.exemption.code} #{ex.exemption.summary}" }
  end
end
