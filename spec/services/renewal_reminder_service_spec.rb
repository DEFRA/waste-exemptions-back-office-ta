# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderService do
  describe ".run" do
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
  end
end
