# frozen_string_literal: true

require "csv"
require_relative "registration_epr_export_report"
require_relative "bulk_export_file"

module DefraRuby
  module Exporters
    module RegistrationExportService

      def self.epr_export
        config.ensure_valid
        file_path = full_path("#{config.epr_export_filename}.csv")
        File.new(file_path, "wb")
        write_to_file(RegistrationEprExportReport, file_path)
        save_to_s3(:epr, file_path)
        File.delete(file_path) if File.exist? file_path
      end

      def self.bulk_export
        config.ensure_valid
        oldest = RegistrationEprExportReport.query.first.registered_on
        newest = RegistrationEprExportReport.query.last.registered_on
        date_ranges = date_range_helper.generate_date_ranges(oldest, newest, config.bulk_export_number_of_months)

        # Clear the existing exports
        export_bucket(:bulk).clear!
        DefraRuby::Exporters::BulkExportFile.destroy_all

        date_ranges.each do |date_range|
          date_range_description = date_range_helper.describe_date_range(date_range)
          file_name = "#{config.bulk_export_filename_base}_#{date_range_description}.csv"
          file_path = full_path(file_name)
          File.new(file_path, "wb")
          write_to_file(RegistrationBulkExportReport, file_path, filter: { date_range: date_range })
          save_to_s3(:bulk, file_path)
          File.delete(file_path) if File.exist? file_path
          DefraRuby::Exporters::BulkExportFile.create(file_name: file_name)
        end
      end

      def self.write_to_file(report_class, file_path, options = {})
        exporter_name = report_class.name.demodulize
        Rails.logger.info "Started writing #{file_path} from #{exporter_name}"

        headers = report_class::COLUMNS.map { |c| c[:header] }
        attributes = report_class::COLUMNS.map { |c| c[:attribute] }

        data_query = options[:filter].present? ? report_class.query(options[:filter]) : report_class.query

        CSV.open(file_path, "wb", force_quotes: true) do |csv|
          csv.flush
          csv << headers

          data_query.find_in_batches(batch_size: config.batch_size.to_i) do |batch|
            batch.each do |record|
              # Evaluate the chained messages that define each attribute on rep
              csv << attributes.map { |a| a.split(".").reduce(record, :try) }
            end

            csv.flush
          end
        end

        Rails.logger.info "Finished writing #{file_path} from #{exporter_name}"
      end

      def self.save_to_s3(export_type, file_path)
        Rails.logger.info "Started upload of #{file_path} to s3"

        s3_object = export_bucket(export_type).object(File.basename(file_path))
        result = s3_object.upload_file(file_path, server_side_encryption: :AES256)

        Rails.logger.info "Finished upload of #{file_path} to s3"

        result
      end

      def self.presigned_url(export_type, file_name)
        export_bucket(export_type)
          .object(file_name)
          .presigned_url(
            :get,
            expires_in: 20 * 60, # 20 minutes in seconds
            secure: true,
            response_content_type: "text/csv",
            response_content_disposition: "attachment; filename=#{file_name}"
          )
      end

      private_class_method def self.config
        DefraRuby::Exporters.configuration
      end

      private_class_method def self.date_range_helper
        DefraRuby::Exporters::Helpers::DateRange
      end

      private_class_method def self.full_path(file_name)
        Rails.root.join "tmp", file_name
      end

      private_class_method def self.export_bucket(export_type)
        aws_config = {
          epr: { credentials: config.epr_export_aws_credentials, bucket: config.epr_export_s3_bucket },
          bulk: { credentials: config.bulk_export_aws_credentials, bucket: config.bulk_export_s3_bucket }
        }

        s3 = Aws::S3::Resource.new(
          region: config.aws_region,
          credentials: aws_config[export_type][:credentials]
        )

        s3.bucket(aws_config[export_type][:bucket])
      end
    end
  end
end
