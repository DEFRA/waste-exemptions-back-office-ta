# frozen_string_literal: true

class ResendRenewalEmailController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize

    begin
      RenewalReminderMailer.first_reminder_email(registration).deliver_now

      flash_success I18n.t("resend_renewal_email.messages.success", email: registration.contact_email)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reference
      Rails.logger.error "Failed to send renewal email for registration #{registration.reference}"

      message = I18n.t("resend_renewal_email.messages.failure", email: registration.contact_email)
      description = I18n.t("resend_renewal_email.messages.failure_details")

      flash_error(message, description)
    end

    redirect_to :back
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
