# frozen_string_literal: true

module AdPrivacyPolicyHelper
  def link_to_privacy_policy
    link_to(t(".privacy_policy"), page_path("privacy"), target: "_blank")
  end

  def destination_path
    if @registration.present?
      renew_path(reference: @registration.reference)
    else
      WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path(:new)
    end
  end
end
