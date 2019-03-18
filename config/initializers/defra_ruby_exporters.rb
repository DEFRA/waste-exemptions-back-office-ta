# frozen_string_literal: true

module DefraRuby
  module Exporters
    BATCH_SIZE = (ENV["EXPORT_SERVICE_BATCH_SIZE"] || 3000).to_i

    AWS_REGION = (ENV["AWS_REGION"] || "eu-west-1")

    EPR_EXPORT_AWS_CREDENTIALS = Aws::Credentials.new(
      (ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"] || raise_missing_env_var("AWS_DAILY_EXPORT_ACCESS_KEY_ID")),
      (ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"] || raise_missing_env_var("AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"))
    )

    EPR_EXPORT_S3_BUCKET = (ENV["AWS_DAILY_EXPORT_BUCKET"] || raise_missing_env_var("AWS_DAILY_EXPORT_BUCKET"))

    EPR_EXPORT_FILENAME = "waste_exemptions_epr_daily_full.csv"

    EPR_EXPORT_TIME = (ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"] || "1:05")

    def self.raise_missing_env_var(variable)
      raise("Environment variable #{variable} has not been set")
    end
  end
end
