# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchService do
  let(:registration) { create(:registration) }
  let(:other_registration) { create(:registration) }

  let(:new_registration) { create(:new_registration) }
  let(:other_new_registration) { create(:new_registration) }

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

    context "when the model is set to new_registrations" do
      let(:model) { :new_registrations }
      let(:term) { new_registration.applicant_first_name }

      it "should return matching new_registrations" do
        expect(results).to include(new_registration)
      end

      it "should not return non-matching new_registrations" do
        expect(results).to_not include(other_new_registration)
      end
    end

    context "when the search term has excess whitespace" do
      let(:term) { "  foo  " }

      it "ignores the whitespace when searching" do
        expect(WasteExemptionsEngine::Registration).to receive(:search_registration_and_relations).with("foo")
        results
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
