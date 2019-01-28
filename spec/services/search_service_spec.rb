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

  it "should return matching registrations" do
    expect(results).to include(registration)
  end

  it "should not return non-matching registrations" do
    expect(results).to_not include(other_registration)
  end
end
