# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe AdRenewalLettersExport, type: :model do
    subject(:ad_renewal_letters_export) { create(:ad_renewal_letters_export) }

    describe "Validations" do
      it "validates uniqueness of expires_on" do
        invalid_record = build(:ad_renewal_letters_export, expires_on: ad_renewal_letters_export.expires_on)

        expect(invalid_record).to_not be_valid
      end
    end

    describe "#export!" do
      it "kick off an export service job" do
        expect(AdRenewalLettersExportService).to receive(:run).with(ad_renewal_letters_export)

        ad_renewal_letters_export.export!
      end
    end
  end
end
