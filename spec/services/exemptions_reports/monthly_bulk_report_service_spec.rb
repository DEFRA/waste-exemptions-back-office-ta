# frozen_string_literal: true

require "rails_helper"

module ExemptionsReports
  RSpec.describe MonthlyBulkReportService do
    describe ".run" do
      it "generates a CSV file containing exemptions for the given month" do
        monthly_bulk_serializer = double(:monthly_bulk_serializer)

        expect(MonthlyBulkSerializer).to receive(:new).and_return(monthly_bulk_serializer)
        expect(monthly_bulk_serializer).to receive(:to_csv)

        MonthlyBulkReportService.run(Date.today)
      end
    end
  end
end
