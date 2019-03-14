# frozen_string_literal: true

# Stubbing HTTP requests
require "webmock/rspec"
# Auto generate fake responses for web-requests
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock

  c.ignore_hosts "127.0.0.1", "codeclimate.com"

  c.default_cassette_options = { re_record_interval: 14.days }

  c.filter_sensitive_data("<AWS_DAILY_EXPORT_ACCESS_KEY_ID>") do
    ENV['AWS_DAILY_EXPORT_ACCESS_KEY_ID']
  end

  c.filter_sensitive_data("<AWS_DAILY_EXPORT_SECRET_ACCESS_KEY>") do
    ENV['AWS_DAILY_EXPORT_SECRET_ACCESS_KEY']
  end

  c.filter_sensitive_data("<AWS_DAILY_EXPORT_BUCKET>") { ENV['AWS_DAILY_EXPORT_BUCKET'] }
end
