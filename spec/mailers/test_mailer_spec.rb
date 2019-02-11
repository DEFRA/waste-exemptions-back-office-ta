# frozen_string_literal: true

require "rails_helper"

RSpec.describe TestMailer, type: :mailer do
  describe "test_email" do
    before do
      allow(Rails.configuration).to receive(:email_test_address).and_return("test@example.com")
      allow(WasteExemptionsEngine.configuration).to receive(:email_service_email).and_return("wex@example.com")
      allow(WasteExemptionsEngine.configuration).to receive(:service_name).and_return("WEX")
    end

    let(:mail) { TestMailer.test_email }

    it "uses the correct 'to' address" do
      expect(mail.to).to eq(["test@example.com"])
    end

    it "uses the correct 'from' address" do
      expect(mail.from).to eq(["wex@example.com"])
    end

    it "uses the correct subject" do
      subject = "WEX email"
      expect(mail.subject).to eq(subject)
    end

    it "includes the correct template in the body" do
      expect(mail.body.encoded).to include("This is a test email")
    end
  end
end
