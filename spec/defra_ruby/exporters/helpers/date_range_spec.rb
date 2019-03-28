# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRuby::Exporters::Helpers::DateRange do
  describe ".generate_date_ranges" do
    let(:one_month) { 1 }
    let(:two_months) { 2 }

    context "when the combination of 'start' and 'end' dates and the 'range_months' results in an ambiguous range" do
      context "and the the range includes January 1st" do
        subject(:date_ranges) do
          start_date = Date.new(2019, 2, 5)
          end_date = Date.new(2019, 2, 17)
          described_class.generate_date_ranges(start_date, end_date, two_months)
        end

        it "uses January 1st as a starting point" do
          expect(date_ranges.count).to eq(1)
          date_range = date_ranges.first
          expect(date_range.first).to eq(Date.new(2019, 1, 1))
          expect(date_range.last).to eq(Date.new(2019, 2, 28))
        end
      end

      context "and the the range excludes January 1st" do
        subject(:date_ranges) do
          start_date = Date.new(2019, 4, 5)
          end_date = Date.new(2019, 5, 17)
          described_class.generate_date_ranges(start_date, end_date, two_months)
        end

        it "defines the range as starting n months from January 1st" do
          expect(date_ranges.count).to eq(2)
          first_date_range = date_ranges.first
          expect(first_date_range.first).to eq(Date.new(2019, 3, 1))
          expect(first_date_range.last).to eq(Date.new(2019, 4, 30))

          second_date_range = date_ranges.last
          expect(second_date_range.first).to eq(Date.new(2019, 5, 1))
          expect(second_date_range.last).to eq(Date.new(2019, 6, 30))
        end
      end
    end

    context "when the span of 'start' to 'end' is shorter than the number of months for each range" do
      context "and the 'start' and 'end' dates are encompassed by a single date range" do
        subject(:date_ranges) do
          start_date = Date.new(2019, 4, 5)
          end_date = Date.new(2019, 4, 17)
          described_class.generate_date_ranges(start_date, end_date, one_month)
        end

        it "returns an array containing a single date range" do
          expect(date_ranges).to be_a(Array)
          expect(date_ranges.count).to eq(1)
        end

        it "the returned date range represents the full range and not just the 'start' and 'end' dates" do
          date_range = date_ranges.first
          expect(date_range.first).to eq(Date.new(2019, 4, 1))
          expect(date_range.last).to eq(Date.new(2019, 4, 30))
        end
      end

      context "and the 'start' and 'end' dates span multiple ranges" do
        subject(:date_ranges) do
          start_date = Date.new(2019, 3, 17)
          end_date = Date.new(2019, 4, 5)
          described_class.generate_date_ranges(start_date, end_date, one_month)
        end

        it "returns an array containing multiple date ranges" do
          expect(date_ranges).to be_a(Array)
          expect(date_ranges.count).to eq(2)
        end

        it "the returned date ranges represent full ranges and not just the 'start' and 'end' dates" do
          first_date_range = date_ranges.first
          expect(first_date_range.first).to eq(Date.new(2019, 3, 1))
          expect(first_date_range.last).to eq(Date.new(2019, 3, 31))

          second_date_range = date_ranges.last
          expect(second_date_range.first).to eq(Date.new(2019, 4, 1))
          expect(second_date_range.last).to eq(Date.new(2019, 4, 30))
        end
      end
    end

    context "when the span of 'start' to 'end' is longer than the number of months for each range" do
      subject(:date_ranges) do
        start_date = Date.new(2019, 2, 17)
        end_date = Date.new(2019, 4, 5)
        described_class.generate_date_ranges(start_date, end_date, one_month)
      end

      it "returns an array containing multiple date ranges" do
        expect(date_ranges).to be_a(Array)
        expect(date_ranges.count).to eq(3)
      end

      it "the returned date ranges represent full ranges and not just the 'start' and 'end' dates" do
        first_date_range = date_ranges.first
        expect(first_date_range.first).to eq(Date.new(2019, 2, 1))
        expect(first_date_range.last).to eq(Date.new(2019, 2, 28))

        second_date_range = date_ranges[1]
        expect(second_date_range.first).to eq(Date.new(2019, 3, 1))
        expect(second_date_range.last).to eq(Date.new(2019, 3, 31))

        third_date_range = date_ranges.last
        expect(third_date_range.first).to eq(Date.new(2019, 4, 1))
        expect(third_date_range.last).to eq(Date.new(2019, 4, 30))
      end
    end
  end

  describe ".describe_date_range" do
    it "returns a string representation of the date range" do
      date_range = Date.new(2019, 1, 1)..Date.new(2019, 3, 31)
      expect(described_class.describe_date_range(date_range)).to eq("20190101-20190331")
    end
  end

  describe ".parse_date_range_description" do
    it "returns the date range described by the given string" do
      date_range = Date.new(2019, 1, 1)..Date.new(2019, 3, 31)
      expect(described_class.parse_date_range_description("20190101-20190331")).to eq(date_range)
    end
  end
end
