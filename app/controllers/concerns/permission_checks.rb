# frozen_string_literal: true

module PermissionChecks
  include WasteExemptionsEngine::PermissionChecks

  def current_user_can_edit?
    authorize! :update, WasteExemptionsEngine::Registration.new
  end
end
