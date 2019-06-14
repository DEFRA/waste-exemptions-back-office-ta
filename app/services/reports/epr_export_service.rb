# frozen_string_literal: true

require_relative "concerns/can_load_file_to_aws"

module Reports
  class EprExportService < ::WasteExemptionsEngine::BaseService
    include CanLoadFileToAws

    def run
      populate_temp_file

      load_file_to_aws_bucket
    rescue StandardError => e
      Airbrake.notify e, file_name: file_name
      Rails.logger.error "Generate EPR export csv error for #{file_name}:\n#{e}"
    ensure
      File.unlink(file_path)
    end

    private

    def populate_temp_file
      File.open(file_path, "w+") { |file| file.write(epr_report) }
    end

    def file_path
      Rails.root.join("tmp/#{file_name}.csv")
    end

    def file_name
      WasteExemptionsBackOffice::Application.config.epr_export_filename
    end

    def epr_report
      EprSerializer.new.to_csv
    end

    def bucket_name
      WasteExemptionsBackOffice::Application.config.epr_reports_bucket_name
    end
  end
end