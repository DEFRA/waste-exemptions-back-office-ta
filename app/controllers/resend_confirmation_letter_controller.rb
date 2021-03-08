# frozen_string_literal: true

class ResendConfirmationLetterController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize

    @registration = registration
  end

  def create
    authorize

    begin
      WasteExemptionsEngine::NotifyConfirmationLetterService.run(registration: registration)

      flash_success I18n.t("resend_confirmation_letter.messages.success", reference: registration.reference)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reference
      Rails.logger.error "Failed to re-send confirmation letter for registration #{registration.reference}"

      message = I18n.t("resend_confirmation_letter.messages.failure", reference: registration.reference)
      description = I18n.t("resend_confirmation_letter.messages.failure_details")

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
