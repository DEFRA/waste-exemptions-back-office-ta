# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchService do
  let(:registration) { create(:registration) }
  let(:other_registration) { create(:registration) }

  let(:transient_registration) { create(:transient_registration) }
  let(:other_transient_registration) { create(:transient_registration) }

  let(:term) { registration.reference }
  let(:model) { nil }

  let(:results) do
    service = SearchService.new
    service.search(term, model, 1)
  end

  context "when a search term is provided" do
    context "when the model is set to registrations" do
      let(:model) { :registrations }

      it "should return matching registrations" do
        expect(results).to include(registration)
      end

      it "should not return non-matching registrations" do
        expect(results).to_not include(other_registration)
      end
    end

    context "when the model is set to transient_registrations" do
      let(:model) { :transient_registrations }
      let(:term) { transient_registration.reference }

      it "should return matching transient_registrations" do
        expect(results).to include(transient_registration)
      end

      it "should not return non-matching transient_registrations" do
        expect(results).to_not include(other_transient_registration)
      end
    end
  end

  context "when no search term is provided" do
    let(:term) { nil }

    it "should return no results" do
      expect(results.length).to eq(0)
    end
  end
end
