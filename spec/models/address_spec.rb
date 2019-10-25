# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Address, type: :model do
  let(:matching_address) { create(:address, :site_uses_address) }
  let(:non_matching_address) { create(:address, :contact) }
  let(:nccc_address) { create(:address, :contact, postcode: "S9 4WF") }
  let(:non_nccc_address) { create(:address, :contact, postcode: "AA1 1AA") }

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

  describe "#nccc" do
    let(:scope) { WasteExemptionsEngine::Address.nccc }

    it "returns NCCC addresses" do
      expect(scope).to include(nccc_address)
    end

    it "does not return non-NCCC addresses" do
      expect(scope).not_to include(non_nccc_address)
    end
  end

  describe "#not_nccc" do
    let(:scope) { WasteExemptionsEngine::Address.not_nccc }

    it "returns non-NCCC addresses" do
      expect(scope).to include(non_nccc_address)
    end

    it "does not return NCCC addresses" do
      expect(scope).not_to include(nccc_address)
    end
  end
end
