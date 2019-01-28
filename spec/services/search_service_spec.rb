# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchService do
  let(:registration) { create(:registration) }
  let(:other_registration) { create(:registration) }
  let(:term) { registration.reference }

  let(:results) do
    service = SearchService.new
    service.search(term, 1)
  end

  context "when a search term is provided" do
    it "should return matching registrations" do
      expect(results).to include(registration)
    end

    it "should not return non-matching registrations" do
      expect(results).to_not include(other_registration)
    end
  end

  context "when no search term is provided" do
    let(:term) { nil }

    it "should return no results" do
      expect(results.length).to eq(0)
    end
  end
end
