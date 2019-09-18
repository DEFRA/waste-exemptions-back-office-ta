# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdRenewalLettersExportCleanerService do
  describe ".run" do
    let(:bucket) { double(:bucket) }
    let(:ad_renewal_letters_export) do
      create(:ad_renewal_letters_export, created_at: 3.weeks.ago, file_name: "example.txt")
    end

    it "mark as deleted all records oldert than a specified date and delete their associated files" do
      # Expect no error
      expect(Airbrake).to_not receive(:notify)

      expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
      expect(bucket).to receive(:delete).with("example.txt")
      expect { described_class.run(3.weeks.ago) }.to change { ad_renewal_letters_export.reload.status }.to("deleted")
    end

    context "if an error happens" do
      it "report the error to Rails and Airbrake" do
        expect(WasteExemptionsEngine::AdRenewalLettersExport).to receive(:not_deleted).and_raise("An Error!")

        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)

        described_class.run(3.weeks.ago)
      end
    end
  end
end
