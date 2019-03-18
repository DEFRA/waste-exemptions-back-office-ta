# frozen_string_literal: true

WasteExemptionsEngine.configure do |configuration|
  # General config
  configuration.application_name = "waste-exemptions-back-office-ta"
  configuration.git_repository_url = "https://github.com/DEFRA/waste-exemptions-back-office-ta"

  # Companies house API config
  configuration.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
  configuration.companies_house_api_key = ENV["COMPANIES_HOUSE_API_KEY"]

  # Addressbase facade config
  configuration.addressbase_url = ENV["ADDRESSBASE_URL"] || "http://localhost:9002"
  # Email config
  configuration.service_name = ENV["EMAIL_SERVICE_NAME"] || "Waste Exemptions Service"
  configuration.email_service_email = ENV["EMAIL_SERVICE_EMAIL"] || "wex-local@example.com"

  # Assisted digital config
  configuration.default_assistance_mode = "full"

  # PDF config
  configuration.use_xvfb_for_wickedpdf = ENV["USE_XVFB_FOR_WICKEDPDF"] || "true"
end
