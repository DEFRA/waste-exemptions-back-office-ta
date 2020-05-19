# frozen_string_literal: true

class ConfirmationLettersBulkPdfService < ::WasteExemptionsEngine::BaseService
  def run(registrations)
    return unless registrations.any?

    @registrations = registrations

    ApplicationController.new.render_to_string(
      pdf: true,
      template: "confirmation_letter/bulk",
      disable_smart_shrinking: true,
      margin: { top: "20mm", bottom: "30mm", left: "20mm", right: "20mm" },
      page_size: "A4",
      print_media_type: true,
      layout: false,
      locals: locals
    )
  rescue StandardError => e
    Airbrake.notify e
    Rails.logger.error "Generate AD confirmation letters PDF bulk error:\n#{e}"

    raise e
  end

  private

  def locals
    {
      presenters: presenters
    }
  end

  def presenters
    @registrations.map do |registration|
      ConfirmationLetterPresenter.new(registration)
    end
  end
end
