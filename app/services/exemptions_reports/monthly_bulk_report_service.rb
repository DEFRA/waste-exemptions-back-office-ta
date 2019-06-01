# frozen_string_literal: true

module ExemptionsReports
  class MonthlyBulkReportService < ::WasteExemptionsEngine::BaseService
    def run(first_day_of_the_month)
      # generate_file_content

      # fill_file

      # upload file to s3

      # if upload successfull
        # record content created
      # else
        # retry 3 times then exit with failure
      # end
    end
  end
end
