# frozen_string_literal: true

require "rails_helper"

module BoxiExport
  RSpec.describe RegistrationExemptionsSerializer do
    subject(:registration_exemptions_serializer) { described_class.new }

    it_behaves_like "A Boxi serializer"

    describe "#to_csv" do
      it "generates a csv file with data content" do
        create(:registration_exemption)

        result = registration_exemptions_serializer.to_csv
        result_lines = result.split("\n")

        expect(result_lines.first.split(",")).to include(*WasteExemptionsEngine::RegistrationExemption.column_names)
        expect(result_lines.count).to eq(2)
      end
    end
  end
end
