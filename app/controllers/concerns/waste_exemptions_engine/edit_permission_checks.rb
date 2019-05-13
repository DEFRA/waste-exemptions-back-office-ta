# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join(
  "app",
  "controllers",
  "concerns",
  "waste_exemptions_engine",
  "edit_permission_checks"
)

module WasteExemptionsEngine
  module EditPermissionChecks
    included do
      def current_user_can_edit?
        authorize! :update, WasteExemptionsEngine::Registration.new
      end
    end
  end
end
