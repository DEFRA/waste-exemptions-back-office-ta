# frozen_string_literal: true

module Reports
  class BulkExportService < ::WasteExemptionsEngine::BaseService
    def run
      return if WasteExemptionsEngine::Registration.count == 0

      GeneratedReport.delete_all

      first_day_of_the_month = starts_from

      while first_day_of_the_month < Date.today
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
