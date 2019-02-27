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
end
