require File.expand_path('../boot', __FILE__)

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
    config.time_zone = "UTC"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths += %W(#{config.root}/lib/defra_ruby/exporters/)

    # Don't add field_with_errors div wrapper around fields with errors. When
    # rails does this it messes with the GOV.UK styling and causes checkboxes
    # and radio buttons to become invisible
    config.action_view.field_error_proc = proc { |html_tag, _instance|
      "#{html_tag}".html_safe
    }

    # Paths
    config.front_office_url = ENV["FRONT_OFFICE_URL"] || "http://localhost:3001"
    config.back_office_url = ENV["BACK_OFFICE_URL"] || "http://localhost:8001"

    # Addressbase facade config
    config.addressbase_url = ENV["ADDRESSBASE_URL"] || "http://localhost:9002"

    # Companies House config
    config.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
    config.companies_house_api_key = ENV["COMPANIES_HOUSE_API_KEY"]

    config.years_before_expiry = ENV["YEARS_BEFORE_EXPIRY"] || 3

    # Emails
    config.email_test_address = ENV["EMAIL_TEST_ADDRESS"]

    # Version info
    config.application_name = "waste-exemptions-back-office-ta"
    config.git_repository_url = "https://github.com/DEFRA/#{config.application_name}"
  end
end
