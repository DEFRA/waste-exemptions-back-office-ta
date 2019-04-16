# frozen_string_literal: true

module WasteExemptionsEngine
  class EditFormsController < FormsController
    def new
      super(EditForm, "edit_form")
    end

    def create
      super(EditForm, "edit_form")
    end

    private

    def find_or_initialize_registration(token)
      if /^WEX/.match?(token)
        find_or_initialize_edited_registration(token)
      else
        super
      end
    end

    def find_or_initialize_edited_registration(reference)
      @transient_registration = EditedRegistration.where(
        reference: reference
      ).first || EditedRegistration.new(reference: reference)
    end
  end
end
