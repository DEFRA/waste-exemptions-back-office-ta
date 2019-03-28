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
          open_date, close_date = [open_date, close_date].sort
          ranges = []
          date_range = create_date_range(initial_date(open_date), range_months)
          loop do
            ranges << date_range if date_in_or_before_range?(open_date, date_range)
            return ranges if final_range?(close_date, date_range)

            date_range = create_date_range(date_range.last + 1.day, range_months)
          end
        end

        def self.describe_date_range(range)
          "#{range.first.strftime('%Y%m%d')}-#{range.last.strftime('%Y%m%d')}"
        end

        def self.parse_date_range_description(description)
          first_date, second_date = description.split("-")
          Date.parse(first_date)..Date.parse(second_date)
        end

        private_class_method def self.initial_date(open_date)
          date = Date.new(open_date.year, BASE_MONTH, BASE_DAY)
          # This is necessary if the base date changes to anything other than January 1st:
          date -= 1.year if open_date < date
          date
        end

        private_class_method def self.create_date_range(start_date, num_months)
          start_date..(start_date + num_months.months - 1.day)
        end

        private_class_method def self.date_in_or_before_range?(date, range)
          range.include?(date) || date < range.first
        end

        private_class_method def self.final_range?(end_date, range)
          range.include?(end_date)
        end
      end
    end
  end
end
