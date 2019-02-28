# frozen_string_literal: true

module DashboardsHelper
  def preselect_registrations_radio_button?
    return true if @filter.blank?

    @filter == :registrations
  end

  def preselect_transient_registrations_radio_button?
    @filter == :transient_registrations
  end

  def status_tag_for(result)
    return :transient if result.is_a?(WasteExemptionsEngine::TransientRegistration)

    :active
  end

  def view_link_for(result)
    if result.is_a?(WasteExemptionsEngine::Registration)
      registration_path(result)
    elsif result.is_a?(WasteExemptionsEngine::TransientRegistration)
      transient_registration_path(result)
    else
      "#"
    end
  end

  def result_name_for_visually_hidden_text(result)
    result.operator_name || result.reference || "new registration"
  end
end
