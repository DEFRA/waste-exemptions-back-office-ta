# frozen_string_literal: true

class RenewalLetterController < ApplicationController
  def show
    registration = WasteExemptionsEngine::Registration.find(params[:id])
    authorize! :read, registration

    show_as_html = params[:show_as_html].present? && params[:show_as_html] == "true"

    render pdf: registration.reference,
           show_as_html: show_as_html,
           layout: false,
           locals: { presenter: RenewalLetterPresenter.new(registration, view_context) },
           disable_smart_shrinking: true,
           margin: { top: "20mm", bottom: "30mm", left: "20mm", right: "20mm" },
           page_size: "A4",
           print_media_type: true
  end
end
