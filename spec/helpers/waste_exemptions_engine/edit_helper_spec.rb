# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditHelper, type: :helper do
    let(:edit_registration) { build(:edit_registration) }

    describe "edit_back_path" do
      it "returns the correct value" do
        path = main_app.registration_path(edit_registration.reference)
        expect(helper.edit_back_path(edit_registration)).to eq(path)
      end
    end

    describe "edit_finished_path" do
      it "returns the correct value" do
        path = main_app.registration_path(edit_registration.reference)
        expect(helper.edit_finished_path(edit_registration)).to eq(path)
      end
    end
  end
end
