# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe ExemptionsSerializer do
      subject(:exemptions_serializer) { described_class.new }

      it_behaves_like "A Boxi serializer"

      describe "#to_csv" do
        it "generates a csv file with data content" do
          create(:exemption)

          result = exemptions_serializer.to_csv
          result_lines = result.split("\n")

          expect(result_lines.first.split(",")).to include(*WasteExemptionsEngine::Exemption.column_names)
          expect(result_lines.count).to eq(2)
        end
      end
    end
  end
end
