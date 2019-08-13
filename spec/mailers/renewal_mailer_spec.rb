# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderMailer, type: :mailer do
  before do
    allow(WasteExemptionsEngine.configuration).to receive(:email_service_email).and_return("wex@example.com")
    allow(WasteExemptionsEngine.configuration).to receive(:service_name).and_return("WEX")
    allow(Rails.configuration).to receive(:front_office_url).and_return("https://wex.gov.uk")
  end

  describe "first_reminder_email" do
    let(:registration) { build(:registration, :with_active_exemptions) }
    let(:mail) { RenewalReminderMailer.first_reminder_email(registration) }

    it "uses the correct 'to' address" do
      expect(mail.to).to eq([registration.contact_email])
    end

    it "uses the correct 'from' address" do
      expect(mail.from).to eq(["wex@example.com"])
    end

    it "uses the correct subject" do
      date = registration.registration_exemptions.first.expires_on.to_formatted_s(:day_month_year)
      subject = "Waste exemptions expire on #{date}, renew online now"
      expect(mail.subject).to eq(subject)
    end

    it "includes the correct template in the body" do
      expect(mail.body.parts[0].body.encoded).to include("You can renew online in a few minutes. Renewal is free.")
    end

    it "includes the correct contact name" do
      contact_name = "#{registration.contact_first_name} #{registration.contact_last_name}"
      expect(mail.body.parts[0].body.encoded).to include(contact_name)
    end

    it "includes the correct expiry date" do
      expires_on = registration.registration_exemptions.first.expires_on.to_formatted_s(:day_month_year)
      expect(mail.body.parts[0].body.encoded).to include(expires_on)
    end

    it "includes the correct reference" do
      reference = registration.reference
      expect(mail.body.parts[0].body.encoded).to include(reference)
    end

    it "includes the correct grid reference" do
      grid_reference = registration.site_address.grid_reference
      expect(mail.body.parts[0].body.encoded).to include(grid_reference)
    end

    context "when the site address is an address" do
      let(:registration) { build(:registration, :site_uses_address, :with_active_exemptions) }

      it "includes the correct address" do
        address = registration.site_address
        address_text = "#{address.premises}, #{address.street_address}, #{address.locality}, #{address.city}, #{address.postcode}"
        expect(mail.body.parts[0].body.encoded).to include(address_text)
      end
    end

    it "includes active exemptions" do
      re = registration.registration_exemptions.first
      exemption_text = "#{re.exemption.code} #{re.exemption.summary}"
      expect(mail.body.parts[0].body.encoded).to include(exemption_text)
    end

    it "excludes inactive exemptions" do
      re = registration.registration_exemptions.last
      re.state = :ceased
      exemption_text = "#{re.exemption.code} #{re.exemption.summary}"
      expect(mail.body.parts[0].body.encoded).to_not include(exemption_text)
    end

    it "includes the correct renewal link" do
      url = "https://wex.gov.uk/renew/#{registration.renew_token}"
      expect(mail.body.parts[0].body.encoded).to include(url)
    end
  end
end
