# frozen_string_literal: true

require "rails_helper"

RSpec.describe FirstRenewalReminderService do
  before do
    expect(WasteExemptionsEngine.configuration).to receive(:renewal_window_before_expiry_in_days).and_return("28")

    allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:send_renewal_magic_link).and_return(false)
  end

  describe ".run" do
    context "when the email sending fails" do
      it "report the error in the log and with Airbrake" do
        create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        expect(RenewalReminderMailer).to receive(:first_reminder_email).and_raise("An error")
        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)

        described_class.run
      end
    end

    it "send a first renewal email to all active registrations due to expire in 4 weeks" do
      active_expiring_registration = create(
        :registration,
        registration_exemptions: [
          build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date),
          build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
        ]
      )

      # Create an expiring registration in a non-active status. Make sure we don't pick it up and send an email.
      create(
        :registration,
        registration_exemptions: [
          build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
        ]
      )

      # Create a non-expiring registration in a non-active status. Make sure we don't pick it up and send an email.
      create(
        :registration,
        registration_exemptions: [
          build(:registration_exemption, :active, expires_on: 5.weeks.from_now.to_date)
        ]
      )

      expect { described_class.run }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(ActionMailer::Base.deliveries.last.to).to eq([active_expiring_registration.contact_email])
    end

    it "do not send emails to AD NCCC email addresses" do
      create(
        :registration,
        contact_email: "waste-exemptions@environment-agency.gov.uk",
        registration_exemptions: [
          build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date),
          build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
        ]
      )
      expect { described_class.run }.to_not change { ActionMailer::Base.deliveries.count }
    end

    context "when the magic link feature flag is off" do
      it "uses the correct mailer" do
        registration = create(
          :registration,
          registration_exemptions: [build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date)]
        )

        expect(RenewalReminderMailer).to receive(:first_reminder_email).with(registration)
        described_class.run
      end
    end

    context "when the magic link feature flag is on" do
      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:send_renewal_magic_link).and_return(true)
      end

      it "uses the correct mailer" do
        registration = create(
          :registration,
          registration_exemptions: [build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date)]
        )

        expect(RenewalReminderMailer).to receive(:first_renew_with_magic_link_email).with(registration)
        described_class.run
      end
    end
  end
end
