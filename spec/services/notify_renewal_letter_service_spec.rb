# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyRenewalLetterService do
  describe "run" do
    let(:registration) { create(:registration) }
    let(:service) do
      NotifyRenewalLetterService.run(registration: registration)
    end

    it "sends a letter" do
      VCR.use_cassette("notify_renewal_letter") do
        # Make sure it's a real postcode for Notify validation purposes
        allow_any_instance_of(WasteExemptionsEngine::Address).to receive(:postcode).and_return("BS1 1AA")

        expect_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original

        response = service

        expect(response).to be_a(Notifications::Client::ResponseNotification)
        expect(response.template["id"]).to eq("8251a044-bdbe-4568-a82a-7b499dfe3775")
        expect(response.content["subject"]).to include("Renew your waste exemptions")
      end
    end
  end
end
