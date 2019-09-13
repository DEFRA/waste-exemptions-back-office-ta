# frozen_string_literal: true

require "rails_helper"

module Data
  module Boxi
    RSpec.describe AddressesSerializer do
      subject(:addresses_serializer) { described_class.new }

      it_behaves_like "A Boxi serializer"

      describe "#to_csv" do
        it "generates a csv file with data content" do
          create(:address)

          result = addresses_serializer.to_csv
          result_lines = result.split("\n")

          expect(result_lines.first.split(",")).to include(*WasteExemptionsEngine::Address.column_names)
          expect(result_lines.count).to eq(2)
        end

        context "when the address description contains new lines" do
          it "generates a csv file without new lines" do
            create(:address, :site, description: "sadfsa\r\nfafdafaf\r\nfdfdaf")

            expect(addresses_serializer.to_csv).to_not include("\r\n")
            expect(addresses_serializer.to_csv).to include("sadfsa fafdafaf fdfdaf")
          end
        end
      end
    end
  end
end
