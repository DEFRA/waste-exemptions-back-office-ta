# frozen_string_literal: true

require "defra_ruby/aws"

DefraRuby::Aws.configure do |c|
  c.buckets = [{
    name: ENV["AWS_BULK_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_BULK_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_BULK_EXPORT_SECRET_ACCESS_KEY"]
    }
  }]
end
