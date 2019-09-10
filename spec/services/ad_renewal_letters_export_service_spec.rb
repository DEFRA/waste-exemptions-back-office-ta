# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdRenewalLettersExportService do
  describe ".run" do
    let(:bucket) { double(:bucket) }
    let(:result) { double(:result, successful?: true) }

    context "when there are expiring registrations from AD users" do
      before do
        create_list(:registration, 3, :ad_registration)
        allow(WasteExemptionsBackOffice::Application.config).to receive(:ad_letters_exports_expires_in).and_return(35)
        WasteExemptionsEngine::RegistrationExemption.update_all(expires_on: 35.days.from_now)
        expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(bucket).to receive(:load).and_return(result)
      end

      it "load a file to a AWS bucket and record the content created" do
        expect(Airbrake).to_not receive(:notify)

        expect { described_class.run }.to change { WasteExemptionsEngine::AdRenewalLettersExport.count }.by(1)
      end

      context "when one registration is in a broken status and a PDF cannot be generated for it" do
        it "raises an error on Airbrake but continue the generation for the other letters" do
          registration = create(:registration, :ad_registration, addresses: [])
          registration.registration_exemptions.update_all(expires_on: 35.days.from_now)

          expect(Airbrake).to receive(:notify)

          described_class.run
        end
      end
    end

    context "when an error happen" do
      it "notify Airbrake" do
        expect(RenewalLettersBulkPdfService).to receive(:run).and_raise("An error")
        expect(Airbrake).to receive(:notify)

        described_class.run
      end
    end
  end
end
