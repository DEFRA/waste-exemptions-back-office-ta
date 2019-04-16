# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::EditedRegistration, type: :model do
  describe "#workflow_state" do
    current_state = :edit_complete_form
    subject(:edited_registration) { create(:edited_registration, workflow_state: current_state) }

    context "when a WasteExemptionsEngine::EditedRegistration's state is #{current_state}" do
      it "can not transition to any states" do
        permitted_states = Helpers::EditWorkflowStates.permitted_states(edited_registration)
        expect(permitted_states).to be_empty
      end
    end
  end
end
