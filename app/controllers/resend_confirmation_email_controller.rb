# frozen_string_literal: true

class ResendConfirmationEmailController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize

    begin
      send_emails

      flash_success(success_message)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reference
      Rails.logger.error "Failed to send confirmation email for registration #{registration.reference}"

      flash_error(failure_message, failure_description)
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def registration
    @_registration ||= WasteExemptionsEngine::Registration
                       .includes(registration_exemptions: :exemption)
                       .find_by(reference: params[:reference])
  end

  def authorize
    authorize! :renew, WasteExemptionsEngine::Registration
  end

  def send_emails
    emails_to_contact.each do |email|
      WasteExemptionsEngine::ConfirmationEmailService.run(registration: registration,
                                                          recipient: email)
    end
  end

  def emails_to_contact
    emails = [registration.applicant_email, registration.contact_email]
    emails.delete(WasteExemptionsEngine.configuration.assisted_digital_email)
    emails.uniq
  end

  def success_message
    I18n.t("resend_confirmation_email.messages.success",
           applicant_email: registration.applicant_email,
           contact_email: registration.contact_email,
           default_email: emails_to_contact.first,
           count: emails_to_contact.length)
  end

  def failure_message
    I18n.t("resend_confirmation_email.messages.failure",
           applicant_email: registration.applicant_email,
           contact_email: registration.contact_email,
           default_email: emails_to_contact.first,
           count: emails_to_contact.length)
  end

  def failure_description
    I18n.t("resend_confirmation_email.messages.failure_details")
  end
end
