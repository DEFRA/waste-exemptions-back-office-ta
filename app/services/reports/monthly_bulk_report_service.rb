# frozen_string_literal: true

module Reports
  class MonthlyBulkReportService < ::WasteExemptionsEngine::BaseService
    def run(first_day_of_the_month)
      @first_day_of_the_month = first_day_of_the_month

      # Generate report
      temp_file.write(bulk_report)

      # upload file to s3

      # rubocop:disable Layout/CommentIndentation
      # if upload successfull
        # record content created
      # else
        # retry 3 times then exit with failure
      # end
      # rubocop:enable Layout/CommentIndentation
    ensure
      temp_file.close
      temp_file.unlink
    end

    private

    def temp_file
      @_temp_file ||= Tempfile.new(file_name)
    end

    def file_name
      data_from_date = @first_day_of_the_month.strftime("%Y%m%d")
      data_to_date = @first_day_of_the_month.end_of_month.strftime("%Y%m%d")

      "#{data_from_date}-#{data_to_date}.csv"
    end

    def bulk_report
      MonthlyBulkSerializer.new(@first_day_of_the_month).to_csv
    end
  end
end
