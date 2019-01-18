# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchService do
  let(:results) do
    service = SearchService.new
    service.search
  end

  let(:registration) { create(:registration) }

  it "should return registrations" do
    expect(results).to include(registration)
  end
end
