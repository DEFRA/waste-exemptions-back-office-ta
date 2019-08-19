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
      subject: I18n.t(".renewal_reminder_mailer.first_reminder_email.subject", date: @expiry_date)
    )
  end

  def second_reminder_email(registration)
    assign_values_for_email(registration)

    mail(
      to: registration.contact_email,
      from: from_email,
      subject: I18n.t(".renewal_reminder_mailer.second_reminder_email.subject")
    )
  end

  private

  def magic_link_url(registration)
    token = magic_link_token(registration)
    Rails.configuration.front_office_url + WasteExemptionsEngine::Engine.routes.url_helpers.renew_path(token: token)
  end

  def magic_link_token(registration)
    registration.regenerate_renew_token if registration.renew_token.nil?
    registration.renew_token
  end

  def assign_values_for_email(registration)
    @contact_name = contact_name(registration)
    @expiry_date = expiry_date(registration)
    @reference = reference(registration)
    @site_location = site_location(registration)
    @exemptions = exemptions(registration)
    @magic_link_url = magic_link_url(registration)
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
    relevant_exemptions = registration.registration_exemptions.select do |re|
      re.may_expire? || re.expired?
    end
    relevant_exemptions.map { |ex| "#{ex.exemption.code} #{ex.exemption.summary}" }
  end
end
