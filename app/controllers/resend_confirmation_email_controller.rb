# frozen_string_literal: true

class ResendConfirmationEmailController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize

    begin
      WasteExemptionsEngine::ConfirmationEmailService.run(registration: registration,
                                                          recipient: registration.contact_email)

      flash_success I18n.t("resend_confirmation_email.messages.success", email: registration.contact_email)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reference
      Rails.logger.error "Failed to send confirmation email for registration #{registration.reference}"

      message = I18n.t("resend_confirmation_email.messages.failure", email: registration.contact_email)
      description = I18n.t("resend_confirmation_email.messages.failure_details")

      flash_error(message, description)
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
end
