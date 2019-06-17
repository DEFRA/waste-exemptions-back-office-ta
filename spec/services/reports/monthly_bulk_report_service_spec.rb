# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe MonthlyBulkReportService do
    describe ".run" do
      let(:first_day_of_the_month) { Date.new(2019, 6, 1) }

      context "when the request succeed" do
        it "generates a CSV file containing exemptions for the given months, upload it to AWS and record the upload" do
          stub_successful_request
          create_list(:registration_exemption, 2, :with_registration, registered_on: first_day_of_the_month)

          # Expect no error gets notified
          expect(Airbrake).to_not receive(:notify)

          # rubocop:disable Style/BlockDelimiters
          expect {
            MonthlyBulkReportService.run(first_day_of_the_month)
          }.to change {
            GeneratedReport.count
          }.by(1)
          # rubocop:enable Style/BlockDelimiters

          expect(GeneratedReport.last.file_name).to eq("20190601-20190630.csv")
          expect(GeneratedReport.last.data_from_date).to eq(first_day_of_the_month)
          expect(GeneratedReport.last.data_to_date).to eq(first_day_of_the_month.end_of_month)
        end
      end

      context "when the request fails" do
        it "fails gracefully and report the error" do
          stub_failing_request
          create_list(:registration_exemption, 2, :with_registration, registered_on: first_day_of_the_month)

          # Expect an error to get notified
          expect(Airbrake).to receive(:notify).once

          MonthlyBulkReportService.run(first_day_of_the_month)
        end
      end
    end

    def stub_successful_request
      stub_request(:put, %r{https:\/\/.*\.s3\.eu-west-1\.amazonaws\.com\/20190601-20190630\.csv.*})
    end

    def stub_failing_request
      stub_request(
        :put,
        %r{https:\/\/.*\.s3\.eu-west-1\.amazonaws\.com\/20190601-20190630\.csv.*}
      ).to_return(
        status: 403
      )
    end
  end
end
