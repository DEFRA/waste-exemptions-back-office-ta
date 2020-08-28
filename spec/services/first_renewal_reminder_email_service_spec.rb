# frozen_string_literal: true

require "rails_helper"

RSpec.describe FirstRenewalReminderEmailService do
  describe "run" do
    let(:registration) { create(:registration) }
    let(:service) do
      FirstRenewalReminderEmailService.run(registration: registration)
    end

    it "sends an email" do
      VCR.use_cassette("first_renewal_reminder_email") do
        expect_any_instance_of(Notifications::Client).to receive(:send_email).and_call_original

        response = service

        expect(response).to be_a(Notifications::Client::ResponseNotification)
        expect(response.template["id"]).to eq("1ef273a9-b5e5-4a48-a343-cf6c774b8211")
        expect(response.content["subject"]).to include("renew online now")
      end
    end
  end
end
