# frozen_string_literal: true

module ActionLinksHelper
  def view_link_for(resource)
    if resource.is_a?(WasteExemptionsEngine::Registration)
      registration_path(resource.reference)
    elsif resource.is_a?(WasteExemptionsEngine::NewRegistration)
      new_registration_path(resource.reference)
    else
      "#"
    end
  end

  def resume_link_for(resource)
    return "#" unless resource.is_a?(WasteExemptionsEngine::NewRegistration)

    token = resource.token
    path = "new_#{resource.workflow_state}_path".to_sym
    WasteExemptionsEngine::Engine.routes.url_helpers.public_send(path, token)
  end

  def edit_link_for(resource)
    return "#" unless resource.is_a?(WasteExemptionsEngine::Registration)

    WasteExemptionsEngine::Engine.routes.url_helpers.new_edit_form_path(resource.reference)
  end

  def display_resume_link_for?(resource)
    return false unless resource.is_a?(WasteExemptionsEngine::NewRegistration)

    can?(:update, resource)
  end

  def display_edit_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:update, resource)
  end

  def display_deregister_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:deregister, resource)
  end

  def display_confirmation_letter_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration)
  end
end
