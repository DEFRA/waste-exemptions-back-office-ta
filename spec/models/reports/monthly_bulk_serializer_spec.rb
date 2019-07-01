# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe MonthlyBulkSerializer do
    let(:first_day_of_the_month) { Date.today.beginning_of_month }

    subject(:monthly_bulk_serializer) { described_class.new(first_day_of_the_month) }

    describe "#to_csv" do
      it "return a string in CSV format with complete exemptions details for the given month" do
        create_list(:registration, 3)
        # The registration factories default to creating 3 exemptions per-registration factory.
        total_exemptions = 3 * 3
        csv_lines = monthly_bulk_serializer.to_csv.split("\n")

        expect(csv_lines.first).to eq(described_class::ATTRIBUTES.map(&:to_s).join(","))
        expect(csv_lines.count).to eq(total_exemptions + 1)
      end
    end
  end
end
