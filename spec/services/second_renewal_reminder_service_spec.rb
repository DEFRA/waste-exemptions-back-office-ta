# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecondRenewalReminderService do
  before do
    expect(WasteExemptionsBackOffice::Application.config).to receive(:second_renewal_email_reminder_days).and_return("14")
  end

  describe ".run" do
    context "when the email sending fails" do
      it "report the error in the log and with Airbrake" do
        create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date)
          ]
        )

        expect(RenewalReminderMailer).to receive(:second_reminder_email).and_raise("An error")
        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)

        described_class.run
      end
    end

    it "send a second renewal email to all active registrations due to expire in 2 weeks" do
      active_expiring_registration = create(
        :registration,
        registration_exemptions: [
          build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date),
          build(:registration_exemption, :revoked, expires_on: 2.weeks.from_now.to_date)
        ]
      )

      # Create an expiring registration in a non-active status. Make sure we don't pick it up and send an email.
      create(
        :registration,
        registration_exemptions: [
          build(:registration_exemption, :revoked, expires_on: 2.weeks.from_now.to_date)
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

    it "do not send emails if a registration have already been renewed" do
      registration = create(
        :registration,
        registration_exemptions: [
          build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date)
        ]
      )

      create(:registration, referring_registration: registration)

      expect { described_class.run }.to_not change { ActionMailer::Base.deliveries.count }
    end

    it "do not send emails to AD NCCC email addresses" do
      create(
        :registration,
        contact_email: "waste-exemptions@environment-agency.gov.uk",
        registration_exemptions: [
          build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date),
          build(:registration_exemption, :revoked, expires_on: 2.weeks.from_now.to_date)
        ]
      )
      expect { described_class.run }.to_not change { ActionMailer::Base.deliveries.count }
    end
  end
end
