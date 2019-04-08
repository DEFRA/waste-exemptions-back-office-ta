# frozen_string_literal: true

require "aws-sdk-s3"
require "defra_ruby/exporters"
require_relative "../../lib/defra_ruby/exporters/bulk_export_file"

DefraRuby::Exporters.configure do |c|
  def raise_missing_env_var(variable)
    raise("Environment variable #{variable} has not been set")
  end

  c.bulk_export_file_class = DefraRuby::Exporters::BulkExportFile

  c.batch_size = ENV["EXPORT_SERVICE_BATCH_SIZE"].to_i if ENV["EXPORT_SERVICE_BATCH_SIZE"].present?
  c.aws_region = ENV["AWS_REGION"] if ENV["AWS_REGION"].present?

  c.epr_export_aws_credentials = Aws::Credentials.new(
    (ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"] || raise_missing_env_var("AWS_DAILY_EXPORT_ACCESS_KEY_ID")),
    (ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"] || raise_missing_env_var("AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"))
  )
  c.epr_export_s3_bucket = (ENV["AWS_DAILY_EXPORT_BUCKET"] || raise_missing_env_var("AWS_DAILY_EXPORT_BUCKET"))
  c.epr_export_filename = "waste_exemptions_epr_daily_full"

  c.bulk_export_aws_credentials = Aws::Credentials.new(
    (ENV["AWS_BULK_EXPORT_ACCESS_KEY_ID"] || raise_missing_env_var("AWS_BULK_EXPORT_ACCESS_KEY_ID")),
    (ENV["AWS_BULK_EXPORT_SECRET_ACCESS_KEY"] || raise_missing_env_var("AWS_BULK_EXPORT_SECRET_ACCESS_KEY"))
  )
  c.bulk_export_s3_bucket = (ENV["AWS_BULK_EXPORT_BUCKET"] || raise_missing_env_var("AWS_BULK_EXPORT_BUCKET"))
  c.bulk_export_filename_base = "waste_exemptions_bulk_export"
  if ENV["EXPORT_SERVICE_BULK_NUMBER_OF_MONTHS"].present?
    c.bulk_export_number_of_months = ENV["EXPORT_SERVICE_BULK_NUMBER_OF_MONTHS"].to_i
  end
end
