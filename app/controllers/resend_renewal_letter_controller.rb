# frozen_string_literal: true

class ResendRenewalLetterController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize

    @registration = registration
  end

  def create
    authorize

    begin
      NotifyRenewalLetterService.run(registration: registration)

      flash_success I18n.t("resend_renewal_letter.messages.success", reference: registration.reference)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reference
      Rails.logger.error "Failed to re-send renewal letter for registration #{registration.reference}"

      message = I18n.t("resend_renewal_letter.messages.failure", reference: registration.reference)
      description = I18n.t("resend_renewal_letter.messages.failure_details")

      flash_error(message, description)
    end

    redirect_to registration_path(registration.reference)
  end

  private

  def registration
    @_registration ||= WasteExemptionsEngine::Registration
                       .find_by(reference: params[:reference])
  end

  def authorize
    authorize! :renew, WasteExemptionsEngine::Registration
  end
end
