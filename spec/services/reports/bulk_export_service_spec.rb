# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BulkExportService do
    describe ".run" do
      let(:number_of_months) { 13 }

      it "clear out all existing records from the database" do
        create(:registration)

        expect(GeneratedReport).to receive(:delete_all)
        stub_request(:put, %r{https://.*\.s3\.eu-west-1\.amazonaws\.com.*})

        BulkExportService.run
      end

      it "executes a MonthlyBulkReportService for every month since the first registration was submitted" do
        create(:registration, submitted_at: number_of_months.months.ago)

        expect(MonthlyBulkReportService).to receive(:run).exactly(number_of_months + 1).times

        BulkExportService.run
      end

      context "if there are no registrations to report" do
        it "exit and do nothing" do
          expect(GeneratedReport).to_not receive(:delete_all)
          expect(MonthlyBulkReportService).to_not receive(:run)

          BulkExportService.run
        end
      end
    end
  end
end
