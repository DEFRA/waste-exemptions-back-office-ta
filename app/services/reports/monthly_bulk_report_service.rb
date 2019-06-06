# frozen_string_literal: true

module Reports
  class MonthlyBulkReportService < ::WasteExemptionsEngine::BaseService
    def run(first_day_of_the_month)
      @first_day_of_the_month = first_day_of_the_month

      populate_temp_file

      load_file_to_aws_bucket

      # record_content_created
    rescue StandardError => e
      Airbrake.notify e, file_name: file_name
      Rails.logger.error "Generate bulk export csv error for #{file_name}:\n#{e}"
    ensure
      temp_file.close
      temp_file.unlink
    end

    private

    def populate_temp_file
      temp_file.write(bulk_report)
    end

    def temp_file
      @_temp_file ||= Tempfile.new(file_name)
    end

    def file_name
      data_from_date = @first_day_of_the_month.to_formatted_s(:plain_year_month_day)
      data_to_date = @first_day_of_the_month.end_of_month.to_formatted_s(:plain_year_month_day)

      "#{data_from_date}-#{data_to_date}.csv"
    end

    def bulk_report
      MonthlyBulkSerializer.new(@first_day_of_the_month).to_csv
    end

    def load_file_to_aws_bucket
      result = nil

      3.times do
        result = bucket.load(temp_file)

        break if result.successful?
      end

      raise(result.error) unless result.successful?
    end

    def bucket
      @_bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
    end

    def bucket_name
      ENV["AWS_BULK_EXPORT_BUCKET"]
    end
  end
end
