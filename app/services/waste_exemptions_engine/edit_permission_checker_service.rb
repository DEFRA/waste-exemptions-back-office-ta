# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join(
  "app",
  "services",
  "waste_exemptions_engine",
  "edit_permission_checker_service"
)

module WasteExemptionsEngine
  class EditPermissionCheckerService
    def run(current_user:)
      Ability.new(current_user).authorize!(:update, WasteExemptionsEngine::Registration.new)
    end
  end
end
