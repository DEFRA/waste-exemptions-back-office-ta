# frozen_string_literal: true

module DashboardsHelper
  def preselect_registrations_radio_button?
    return true if @filter.blank?

    @filter == :registrations
  end

  def preselect_new_registrations_radio_button?
    @filter == :new_registrations
  end

  def status_tag_for(result)
    return :pending if result.is_a?(WasteExemptionsEngine::TransientRegistration)

    :active
  end

  def result_name_for_visually_hidden_text(result)
    result.operator_name || result.reference || "new registration"
  end
end
