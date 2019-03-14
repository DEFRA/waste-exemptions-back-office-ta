module DefraRuby
  module Exporters
    BATCH_SIZE = (ENV["EXPORT_SERVICE_BATCH_SIZE"] || 3000).to_i.freeze

    AWS_REGION = (ENV["AWS_REGION"] || "eu-west-1").freeze

    EPR_EXPORT_AWS_CREDENTIALS = Aws::Credentials.new(
      (ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"] || raise("Environment variable AWS_DAILY_EXPORT_ACCESS_KEY_ID has not been set")),
      (ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"] || raise("Environment variable AWS_DAILY_EXPORT_SECRET_ACCESS_KEY has not been set"))
    )

    EPR_EXPORT_S3_BUCKET = (ENV["AWS_DAILY_EXPORT_BUCKET"] || raise("Environment variable AWS_DAILY_EXPORT_BUCKET has not been set")).freeze
  end
end
