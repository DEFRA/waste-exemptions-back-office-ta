# frozen_string_literal: true

require "defra_ruby/aws"

# rubocop:disable Metrics/BlockLength
DefraRuby::Aws.configure do |c|
  bulk_bucket = {
    name: ENV["AWS_BULK_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_BULK_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_BULK_EXPORT_SECRET_ACCESS_KEY"]
    },
    encrypt_with_kms: ENV["AWS_BULK_ENCRYPT_WITH_KMS"]
  }

  epr_bucket = {
    name: ENV["AWS_DAILY_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"]
    },
    encrypt_with_kms: ENV["AWS_DAILY_ENCRYPT_WITH_KMS"]
  }

  boxi_export_bucket = {
    name: ENV["AWS_BOXI_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_BOXI_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_BOXI_EXPORT_SECRET_ACCESS_KEY"]
    },
    encrypt_with_kms: ENV["AWS_BOXI_ENCRYPT_WITH_KMS"]
  }

  c.buckets = [bulk_bucket, epr_bucket, boxi_export_bucket]
end
# rubocop:enable Metrics/BlockLength
