# frozen_string_literal: true

require "rails_helper"

module Data
  RSpec.describe EprExportService do
    describe ".run" do
      context "when the AWS request succeeds" do
        it "generates a CSV file containing all active exemptions and uploads it to AWS" do
          create_list(:registration_exemption, 2, :with_registration, :active)
          file_name = "waste_exemptions_epr_daily_full"

          stub_request(:put, %r{https:\/\/.*\.s3\.eu-west-1\.amazonaws\.com\/#{file_name}\.csv.*})

          # Expect no error gets notified
          expect(Airbrake).to_not receive(:notify)

          EprExportService.run
        end
      end

      context "when the request fails" do
        it "fails gracefully and reports the error" do
          create(:registration_exemption, :with_registration, :active)

          file_name = "waste_exemptions_epr_daily_full"

          stub_request(
            :put,
            %r{https:\/\/.*\.s3\.eu-west-1\.amazonaws\.com\/#{file_name}\.csv.*}
          ).to_return(status: 403)

          # Expect an error to get notified
          expect(Airbrake).to receive(:notify).once

          EprExportService.run
        end
      end
    end
  end
end
