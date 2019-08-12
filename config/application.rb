# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WasteExemptionsBackOffice
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "London"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Don't add field_with_errors div wrapper around fields with errors. When
    # rails does this it messes with the GOV.UK styling and causes checkboxes
    # and radio buttons to become invisible
    config.action_view.field_error_proc = proc { |html_tag, _instance|
      html_tag.to_s.html_safe
    }

    # Paths
    config.front_office_url = ENV["FRONT_OFFICE_URL"] || "http://localhost:3001"
    config.back_office_url = ENV["BACK_OFFICE_URL"] || "http://localhost:8001"

    # Addressbase facade config
    config.addressbase_url = ENV["ADDRESSBASE_URL"] || "http://localhost:9002"

    # Companies House config
    config.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
    config.companies_house_api_key = ENV["COMPANIES_HOUSE_API_KEY"]

    # Data export config
    config.bulk_reports_bucket_name = ENV["AWS_BULK_EXPORT_BUCKET"]
    config.epr_reports_bucket_name = ENV["AWS_DAILY_EXPORT_BUCKET"]
    config.boxi_exports_bucket_name = ENV["AWS_BOXI_EXPORT_BUCKET"]
    config.epr_export_filename = ENV["EPR_DAILY_REPORT_FILE_NAME"] || "waste_exemptions_epr_daily_full"
    config.export_batch_size = ENV["EXPORT_SERVICE_BATCH_SIZE"] || 1000

    config.years_before_expiry = ENV["YEARS_BEFORE_EXPIRY"] || 3

    # Emails
    config.email_test_address = ENV["EMAIL_TEST_ADDRESS"]
    config.second_renewal_email_reminder_days = ENV["SECOND_RENEWAL_EMAIL_BEFORE_DAYS"] || 14

    # Version info
    config.application_name = "waste-exemptions-back-office-ta"
    config.git_repository_url = "https://github.com/DEFRA/#{config.application_name}"
  end
end
