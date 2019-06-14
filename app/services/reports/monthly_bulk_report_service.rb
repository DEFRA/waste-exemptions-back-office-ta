# frozen_string_literal: true

require_relative "concerns/can_load_file_to_aws"

module Reports
  class MonthlyBulkReportService < ::WasteExemptionsEngine::BaseService
    include CanLoadFileToAws

    def run(first_day_of_the_month)
      @first_day_of_the_month = first_day_of_the_month

      populate_temp_file

      load_file_to_aws_bucket

      record_content_created
    rescue StandardError => e
      Airbrake.notify e, file_name: file_name
      Rails.logger.error "Generate bulk export csv error for #{file_name}:\n#{e}"
    ensure
      File.unlink(file_path)
    end

    private

    def populate_temp_file
      File.open(file_path, "w+") { |file| file.write(bulk_report) }
    end

    def file_path
      Rails.root.join("tmp/#{file_name}")
    end

    def file_name
      data_from_date = @first_day_of_the_month.to_formatted_s(:plain_year_month_day)
      data_to_date = @first_day_of_the_month.end_of_month.to_formatted_s(:plain_year_month_day)

      "#{data_from_date}-#{data_to_date}.csv"
    end

    def bulk_report
      MonthlyBulkSerializer.new(@first_day_of_the_month).to_csv
    end

    def bucket_name
      WasteExemptionsBackOffice::Application.config.bulk_reports_bucket_name
    end

    def record_content_created
      GeneratedReport.create!(
        file_name: file_name,
        data_from_date: @first_day_of_the_month,
        data_to_date: @first_day_of_the_month.end_of_month
      )
    end
  end
end
