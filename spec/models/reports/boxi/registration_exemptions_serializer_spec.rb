# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
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

        context "when the address description contains new lines" do
          it "generates a csv file without new lines" do
            create(:registration_exemption, deregistration_message: "sadfsa\r\nfafdafaf\r\nfdfdaf")

            expect(registration_exemptions_serializer.to_csv).to_not include("\r\n")
            expect(registration_exemptions_serializer.to_csv).to include("sadfsa fafdafaf fdfdaf")
          end
        end
      end
    end
  end
end
