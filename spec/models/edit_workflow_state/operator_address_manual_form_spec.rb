# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::EditedRegistration, type: :model do
  describe "#workflow_state" do
    it_behaves_like "a simple bidirectional transition",
                    previous_state: :operator_postcode_form,
                    current_state: :operator_address_manual_form,
                    next_state: :edit_form,
                    factory: :edited_registration
  end
end
