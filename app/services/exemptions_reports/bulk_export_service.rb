# frozen_string_literal: true

module ExemptionsReports
  class BulkExportService < ::WasteExemptionsEngine::BaseService
    def run(*)
      first_day_of_the_month = starts_from

      while(first_day_of_the_month < Date.today)
        MonthlyBulkReportService.run(first_day_of_the_month)

        first_day_of_the_month = first_day_of_the_month.next_month
      end
    end

    private

    def starts_from
      @_starts_from ||= WasteExemptionsEngine::Registration.order(:submitted_at).first.submitted_at.beginning_of_month
    end
  end
end
