# frozen_string_literal: true

require "defra_ruby/aws"

DefraRuby::Aws.configure do |c|
  def raise_missing_env_var(variable)
    raise("Environment variable #{variable} has not been set")
  end

  ENV["AWS_BULK_EXPORT_BUCKET"].present? || raise_missing_env_var("AWS_BULK_EXPORT_BUCKET")
  ENV["AWS_BULK_EXPORT_ACCESS_KEY_ID"].present? || raise_missing_env_var("AWS_BULK_EXPORT_ACCESS_KEY_ID")
  ENV["AWS_BULK_EXPORT_SECRET_ACCESS_KEY"] || raise_missing_env_var("AWS_BULK_EXPORT_SECRET_ACCESS_KEY")

  c.buckets = [{
    name: (ENV["AWS_BULK_EXPORT_BUCKET"] || raise_missing_env_var("AWS_BULK_EXPORT_BUCKET")),
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_BULK_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_BULK_EXPORT_SECRET_ACCESS_KEY"]
    }
  }]
end
