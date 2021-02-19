# frozen_string_literal: true

require "rails_helper"

RSpec.describe BulkNotifyRenewalLettersService do
  describe ".run" do
    let(:ad_registrations) { create_list(:registration, 2, :ad_registration) }
    let(:non_ad_registration) { create(:registration) }
    let(:non_matching_date_registration) { create(:registration, :ad_registration, :expires_tomorrow) }
    let(:inactive_registration) { create(:registration, :ad_registration, :with_ceased_exemptions) }

    let(:expires_on) { ad_registrations.first.registration_exemptions.first.expires_on }

    it "returns a list of relevant references" do
      expect(Airbrake).to_not receive(:notify)

      expect(described_class.run(expires_on)).to eq([ad_registrations[0].reference,
                                                     ad_registrations[1].reference])
      expect(described_class.run(expires_on)).to_not include(non_ad_registration.reference)
      expect(described_class.run(expires_on)).to_not include(non_matching_date_registration.reference)
      expect(described_class.run(expires_on)).to_not include(inactive_registration.reference)
    end

    context "when an error happens" do
      skip "notify Airbrake" do
        expect_any_instance_of(ApplicationController).to receive(:render_to_string).and_raise("An error")
        expect(Airbrake).to receive(:notify)

        expect { described_class.run(expires_on) }.to raise_error("An error")
      end
    end

    context "when there are no registrations" do
      let(:expires_on) { 500.years.ago }

      it "returns a result" do
        expect(described_class.run(expires_on)).to eq([])
      end
    end
  end
end
