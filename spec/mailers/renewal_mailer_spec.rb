# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderMailer, type: :mailer do
  describe "test_email" do
    before do
      allow(WasteExemptionsEngine.configuration).to receive(:email_service_email).and_return("wex@example.com")
      allow(WasteExemptionsEngine.configuration).to receive(:service_name).and_return("WEX")
    end

    let(:registration) { build(:registration) }
    let(:mail) { RenewalReminderMailer.first_reminder_email(registration) }

    it "uses the correct 'to' address" do
      expect(mail.to).to eq([registration.contact_email])
    end

    it "uses the correct 'from' address" do
      expect(mail.from).to eq(["wex@example.com"])
    end

    it "uses the correct subject" do
      subject = "Your waste exemptions expire soon, register again to continue your waste operations"
      expect(mail.subject).to eq(subject)
    end

    it "includes the correct template in the body" do
      expect(mail.body.encoded).to include("Until our online renewal service is launched, you’ll need to register your exemptions again.")
    end

    it "includes the correct contact name" do
      contact_name = "#{registration.contact_first_name} #{registration.contact_last_name}"
      expect(mail.body.encoded).to include(contact_name)
    end
  end
end
