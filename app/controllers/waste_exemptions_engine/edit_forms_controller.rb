# frozen_string_literal: true

module WasteExemptionsEngine
  class EditFormsController < FormsController
    def new
      super(EditForm, "edit_form")
    end

    def create
      super(EditForm, "edit_form")
    end
  end
end
