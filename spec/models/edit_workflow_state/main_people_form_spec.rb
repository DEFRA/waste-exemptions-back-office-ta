# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::EditedRegistration, type: :model do
  describe "#workflow_state" do
    it_behaves_like "a simple unidirectional transition",
                    previous_and_next_state: :edit_form,
                    current_state: :main_people_form,
                    factory: :edited_registration
  end
end
