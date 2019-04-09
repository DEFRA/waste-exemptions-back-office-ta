# frozen_string_literal: true

class ConfirmationLetterController < ApplicationController
  def show
    registration = WasteExemptionsEngine::Registration.find(params[:id])
    authorize! :read, registration

    show_as_html = params[:show_as_html].present? && params[:show_as_html] == "true"

    render pdf: "#{registration.reference}_confirmation_letter",
           show_as_html: show_as_html,
           layout: false,
           locals: { confirmation_letter_data: ConfirmationLetterPresenter.new(registration) },
           page_size: "A4",
           margin: { top: "10mm", bottom: "10mm", left: "10mm", right: "10mm" },
           print_media_type: true
  end
end