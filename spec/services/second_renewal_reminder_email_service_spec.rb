# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecondRenewalReminderEmailService do
  describe "run" do
    let(:registration) { create(:registration, :site_uses_address) }
    let(:service) do
      SecondRenewalReminderEmailService.run(registration: registration)
    end

    it "sends an email" do
      VCR.use_cassette("second_renewal_reminder_email") do
        expect_any_instance_of(Notifications::Client).to receive(:send_email).and_call_original

        response = service

        expect(response).to be_a(Notifications::Client::ResponseNotification)
        expect(response.template["id"]).to eq("80585fc6-9c65-4909-8cb4-6888fa4427c8")
        expect(response.content["subject"]).to eq("Renew your waste exemptions online now")
      end
    end
  end
end
