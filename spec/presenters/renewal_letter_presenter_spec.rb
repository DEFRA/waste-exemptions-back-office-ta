# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalLetterPresenter do
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }

  it_behaves_like "a letter presenter"

  describe "#expiry_date" do
    it "returns the registration's expiry_date formatted as for example '2 April 2019'" do
      parsed_date = Date.parse(subject.expiry_date)

      expect(parsed_date).to eq(registration.registration_exemptions.first.expires_on)
    end
  end
end
