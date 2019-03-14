# frozen_string_literal: true

require "csv"
require_relative "registration_epr_export_report"

module DefraRuby
  module Exporters
    class RegistrationExportService

      EPR_EXPORT_FILENAME = "waste_exemptions_epr_daily_full.csv"

      def epr_export
        file_path = full_path
        write_to_file(RegistrationEprExportReport, file_path)
        save_to_s3(:epr, file_path)
      end

      def write_to_file(report_class, file_path)
        exporter_name = report_class.name.demodulize
        Rails.logger.info "Started writing #{file_path} from #{exporter_name}"

        headers = report_class::COLUMNS.map { |c| c[:header] }
        attributes = report_class::COLUMNS.map { |c| c[:attribute] }

        CSV.open(file_path, "wb", force_quotes: true) do |csv|
          csv.flush
          csv << headers

          report_class.query.find_in_batches(batch_size: BATCH_SIZE) do |batch|
            batch.each do |record|
              # Evaluate the chained messages that define each attribute on rep
              csv << attributes.map { |a| a.split(".").reduce(record, :try) }
            end

            csv.flush
          end
        end

        Rails.logger.info "Finished writing #{file_path} from #{exporter_name}"
      end

      def save_to_s3(export_type, file_path)
        Rails.logger.info "Started daily upload of #{file_path} to s3"

        s3_object = export_bucket(export_type).object(File.basename(file_path))
        result = s3_object.upload_file(file_path, server_side_encryption: :AES256)

        Rails.logger.info "Finished daily upload of #{file_path} to s3"

        result
      end

      private

      def full_path
        Rails.root.join "private", "exports", EPR_EXPORT_FILENAME
      end

      def export_bucket(export_type)
        aws_config = {
          epr: { credentials: EPR_EXPORT_AWS_CREDENTIALS, bucket: EPR_EXPORT_S3_BUCKET }
        }

        s3 = Aws::S3::Resource.new(
          region: AWS_REGION,
          credentials: aws_config[export_type][:credentials]
        )

        s3.bucket(aws_config[export_type][:bucket])
      end

    end
  end
end
