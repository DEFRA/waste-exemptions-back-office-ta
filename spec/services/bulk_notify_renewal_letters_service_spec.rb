# frozen_string_literal: true

require "rails_helper"

RSpec.describe BulkNotifyRenewalLettersService do
  describe ".run" do
    let(:ad_registrations) { create_list(:registration, 2, :ad_registration) }
    let(:non_ad_registration) { create(:registration) }
    let(:non_matching_date_registration) { create(:registration, :ad_registration, :expires_tomorrow) }
    let(:inactive_registration) { create(:registration, :ad_registration, :with_ceased_exemptions) }

    let(:expires_on) { ad_registrations.first.registration_exemptions.first.expires_on }

    it "sends the relevant registrations to the NotifyRenewalLetterService" do
      expect(Airbrake).to_not receive(:notify)

      expect(NotifyRenewalLetterService).to receive(:run).with(registration: ad_registrations[0])
      expect(NotifyRenewalLetterService).to receive(:run).with(registration: ad_registrations[1])

      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: non_ad_registration)
      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: non_matching_date_registration)
      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: inactive_registration)

      described_class.run(expires_on)
    end

    context "when an error happens" do
      it "notifies Airbrake without failing the whole job" do
        expect(NotifyRenewalLetterService).to receive(:run).with(registration: ad_registrations[0]).and_raise("An error")
        expect(Airbrake).to receive(:notify).once
        expect(NotifyRenewalLetterService).to receive(:run).with(registration: ad_registrations[1])

        expect { described_class.run(expires_on) }.to_not raise_error
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
