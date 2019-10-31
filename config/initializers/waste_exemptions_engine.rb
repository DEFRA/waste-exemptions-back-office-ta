# frozen_string_literal: true

WasteExemptionsEngine.configure do |configuration|
  # General config
  configuration.application_name = "waste-exemptions-back-office"
  configuration.git_repository_url = "https://github.com/DEFRA/waste-exemptions-back-office"

  # Companies house API config
  configuration.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
  configuration.companies_house_api_key = ENV["COMPANIES_HOUSE_API_KEY"]

  # Addressbase facade config
  configuration.addressbase_url = ENV["ADDRESSBASE_URL"] || "http://localhost:3002"

  # Email config
  configuration.service_name = ENV["EMAIL_SERVICE_NAME"] || "Waste Exemptions Service"
  configuration.email_service_email = ENV["EMAIL_SERVICE_EMAIL"] || "wex-local@example.com"

  # Assisted digital config
  configuration.default_assistance_mode = "full"

  # Edit config
  configuration.edit_enabled = "true"

  # PDF config
  # Should we use XVFB when rendering PDFs? The reason for asking this is local
  # development environments. If you're working in an environment without a GUI
  # then you want this set to true. However if you are working locally then
  # you'll want to disable it
  configuration.use_xvfb_for_wickedpdf = ENV["USE_XVFB_FOR_WICKEDPDF"] || "true"

  # Last email cache config
  configuration.use_last_email_cache = ENV["USE_LAST_EMAIL_CACHE"] || "false"

  # Renewing config
  configuration.renewal_window_before_expiry_in_days = ENV["RENEWAL_WINDOW_BEFORE_EXPIRY_IN_DAYS"] || 28
  configuration.renewal_window_after_expiry_in_days = ENV["RENEWAL_WINDOW_AFTER_EXPIRY_IN_DAYS"] || 30
end
