# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::TransientAddress, type: :model do
  let(:matching_address) { create(:transient_address, :site) }
  let(:non_matching_address) { create(:transient_address, :contact) }

  describe "#search_for_postcode" do
    let(:term) { nil }
    let(:scope) { WasteExemptionsEngine::TransientAddress.search_for_postcode(term) }

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
    let(:scope) { WasteExemptionsEngine::TransientAddress.site }

    it "returns site addresses" do
      expect(scope).to include(matching_address)
    end

    it "does not return others" do
      expect(scope).not_to include(non_matching_address)
    end
  end
end
