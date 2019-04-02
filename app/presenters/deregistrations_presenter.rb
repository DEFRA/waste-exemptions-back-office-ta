# frozen_string_literal: true

class DeregistrationsPresenter

  attr_reader :registration_reference, :heading, :submit_button, :form_path

  def initialize(resource)
    @type = resource.class.to_s.split("::").last
    @registration_reference = registration? ? resource.reference : resource.registration.reference
    @submit_button = submit_button_text
    @heading = heading_text(resource)
    @form_path = lookup_form_path(resource)
  end

  private

  def registration?
    @type == "Registration"
  end

  def submit_button_text
    button_type = registration? ? @type : "Exemption"
    I18n.t("deregister_exemptions.new.approve_button", type: button_type)
  end

  def heading_text(resource)
    if registration?
      I18n.t("deregister_exemptions.new.registration_heading", registration_reference: registration_reference)
    else
      I18n.t(
        "deregister_exemptions.new.exemptions_heading",
        exemption_code: resource.exemption.code,
        registration_reference: registration_reference
      )
    end
  end

  def lookup_form_path(resource)
    if registration?
      Rails.application.routes.url_helpers.deregister_registrations_path(resource.id)
    else
      Rails.application.routes.url_helpers.deregister_exemptions_path(resource.id)
    end
  end
end
