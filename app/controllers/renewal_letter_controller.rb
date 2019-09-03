# frozen_string_literal: true

class RenewalLetterController < ApplicationController
  include CanRenderPdf

  def show
    registration = WasteExemptionsEngine::Registration.find(params[:id])
    authorize! :read, registration

    render pdf: registration.reference,
           show_as_html: show_as_html?,
           layout: false,
           locals: { presenter: RenewalLetterPresenter.new(registration, view_context) },
           disable_smart_shrinking: true,
           margin: { top: "20mm", bottom: "30mm", left: "20mm", right: "20mm" },
           page_size: "A4",
           print_media_type: true
  end
end
