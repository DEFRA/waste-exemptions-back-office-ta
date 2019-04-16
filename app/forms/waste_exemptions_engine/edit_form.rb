# frozen_string_literal: true

module WasteExemptionsEngine
  class EditForm < BaseForm
    attr_accessor :reference

    def initialize(registration)
      super
      self.reference = @transient_registration.reference
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = {}

      super(attributes, params[:token])
    end
  end
end
