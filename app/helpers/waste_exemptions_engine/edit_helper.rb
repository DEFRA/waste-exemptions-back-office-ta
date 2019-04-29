# frozen_string_literal: true

module WasteExemptionsEngine
  module EditHelper
    def edit_back_path(edit_registration)
      original_registration_path(edit_registration)
    end

    def edit_finished_path(edit_registration)
      original_registration_path(edit_registration)
    end

    private

    def original_registration_path(edit_registration)
      main_app.registration_path(edit_registration.reference)
    end
  end
end
