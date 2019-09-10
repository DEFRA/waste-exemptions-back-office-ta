# frozen_string_literal: true

require "defra_ruby/aws"

DefraRuby::Aws.configure do |c|
  bulk_bucket = {
    name: ENV["AWS_BULK_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_BULK_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_BULK_EXPORT_SECRET_ACCESS_KEY"]
    }
  }

  epr_bucket = {
    name: ENV["AWS_DAILY_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"]
    }
  }

  boxi_export_bucket = {
    name: ENV["AWS_BOXI_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_BOXI_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_BOXI_EXPORT_SECRET_ACCESS_KEY"]
    }
  }

  letters_export_bucket = {
    name: ENV["AWS_LETTERS_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_LETTERS_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_LETTERS_EXPORT_SECRET_ACCESS_KEY"]
    }
  }

  c.buckets = [bulk_bucket, epr_bucket, boxi_export_bucket, letters_export_bucket]
end
