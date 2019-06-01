# frozen_string_literal: true

require "rails_helper"

module ExemptionsReports
  RSpec.describe BulkExportService do
    describe ".run" do
      let(:number_of_months) { 13 }

      it "Executes a MonthlyBulkReportService for every month since the first registration was submitted" do
        create(:registration, submitted_at: number_of_months.months.ago)

        expect(MonthlyBulkReportService).to receive(:run).exactly(number_of_months).times

        BulkExportService.run
      end
    end
  end
end
