# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdRenewalLettersExportService do
  describe ".run" do
    let(:bucket) { double(:bucket) }
    let(:result) { double(:result, successful?: true) }
    let(:ad_renewal_letters_export) { create(:ad_renewal_letters_export, expires_on: 35.days.from_now) }

    before do
      create_list(:registration, 3, :ad_registration)
      WasteExemptionsEngine::RegistrationExemption.update_all(expires_on: 35.days.from_now)
    end

    context "when there are expiring registrations from AD users" do
      before do
        expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(bucket).to receive(:load).and_return(result)
      end

      it "load a file to a AWS bucket and record the content created" do
        expect(Airbrake).to_not receive(:notify)

        described_class.run(ad_renewal_letters_export)

        expect(ad_renewal_letters_export.number_of_letters).to eq(3)
        expect(ad_renewal_letters_export).to be_succeded
      end

      context "when one registration is in an invalid state and a PDF cannot be generated for it" do
        it "raises an error on Airbrake but continues generation for the other letters" do
          registration = create(:registration, :ad_registration, addresses: [])
          registration.registration_exemptions.update_all(expires_on: 35.days.from_now)

          expect(Airbrake).to receive(:notify)

          described_class.run(ad_renewal_letters_export)

          expect(ad_renewal_letters_export.number_of_letters).to eq(4)
          expect(ad_renewal_letters_export).to be_succeded
        end
      end
    end

    context "when an error happens" do
      it "notify Airbrake" do
        expect(RenewalLettersBulkPdfService).to receive(:run).and_raise("An error")
        expect(Airbrake).to receive(:notify)

        described_class.run(ad_renewal_letters_export)
        expect(ad_renewal_letters_export).to be_failed
      end
    end
  end
end