# frozen_string_literal: true

require "date"

module DefraRuby
  module Exporters
    module Helpers
      module DateRange
        # Use January 1st as the starting point for generating the date ranges.
        BASE_MONTH = 1
        BASE_DAY = 1

        # Given an arbitrary open_date, arbitrary close_date, the length of each range in months,
        # and base day of the year, return the date ranges needed to encompass the start and end dates.
        # For example:
        # > ranges = self.generate_date_ranges(DateTime.new(2019, 02, 05), DateTime.new(2019, 03, 17), 2)
        # The following are true
        # > ranges.count == 2
        # > ranges.first == DateTime.new(2019, 01, 01)..DateTime.new(2019, 02, 28)
        # > ranges.last  == DateTime.new(2019, 03, 01)..DateTime.new(2019, 04, 30)
        def self.generate_date_ranges(open_date, close_date, range_months)
          # Make sure the open_date is before the close_date
          open_date, close_date = close_date, open_date unless open_date <= close_date
          ranges = []
          initial_date = Date.new(open_date.year, BASE_MONTH, BASE_DAY)
          # This is necessary if the base date changes to anything other than January 1st:
          initial_date -= 1.year if open_date < initial_date
          date_range = initial_date..(initial_date + range_months.months - 1.day)
          loop do
            ranges << date_range if date_range.include?(open_date) || open_date < date_range.first
            return ranges if date_range.include?(close_date)

            range_start = date_range.last + 1.day
            date_range = range_start..(range_start + range_months.months - 1.day)
          end
        end

        def self.describe_date_range(range)
          "#{range.first.strftime('%Y%m%d')}-#{range.last.strftime('%Y%m%d')}"
        end

        def self.parse_date_range_description(description)
          first_date, second_date = description.split("-")
          Date.parse(first_date)..Date.parse(second_date)
        end
      end
    end
  end
end
