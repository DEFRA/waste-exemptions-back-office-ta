# frozen_string_literal: true

module PathsHelper
  def view_link_for(resource)
    if resource.is_a?(WasteExemptionsEngine::Registration)
      registration_path(resource.reference)
    elsif resource.is_a?(WasteExemptionsEngine::TransientRegistration)
      transient_registration_path(resource.reference)
    else
      "#"
    end
  end
end
