# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Address, type: :model do
  let(:matching_address) { create(:address, :site_uses_address) }
  let(:non_matching_address) { create(:address, :contact) }

  context "scopes" do
    describe ".with_easting_and_northing" do
      it "returns all address with x and y information" do
        create(:address, x: nil, y: 123.4)
        create(:address, x: 123.4, y: nil)

        valid_address = create(:address, x: 123.4, y: 123.4)

        expect(described_class.with_easting_and_northing.size).to eq(1)
        expect(described_class.with_easting_and_northing.first).to eq(valid_address)
      end
    end

    describe ".missing_ea_area" do
      it "returns all address with a missing EA area" do
        create(:address, area: "West Midlands")

        nil_area = create(:address, area: nil)
        empty_area = create(:address, area: "")

        expect(described_class.missing_ea_area.size).to eq(2)
        expect(described_class.missing_ea_area).to include(empty_area)
        expect(described_class.missing_ea_area).to include(nil_area)
      end
    end
  end

  describe "#search_for_postcode" do
    let(:term) { nil }
    let(:scope) { WasteExemptionsEngine::Address.search_for_postcode(term) }

    context "when the search term is a postcode" do
      let(:term) { matching_address.postcode }

      it "returns addresses with a matching postcode" do
        expect(scope).to include(matching_address)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_address)
      end
    end
  end

  describe "#site" do
    let(:scope) { WasteExemptionsEngine::Address.site }

    it "returns site addresses" do
      expect(scope).to include(matching_address)
    end

    it "does not return others" do
      expect(scope).not_to include(non_matching_address)
    end
  end
end
