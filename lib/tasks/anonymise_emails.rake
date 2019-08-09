# frozen_string_literal: true

desc "Set all email domain addresses to given address or default one." \
      " Usage: `rake anonymise_emails TEST_DOMAIN=test@testmedefra.gov.uk`"
task anonymise_emails: :environment do
  test_email = ENV["TEST_EMAIL"].presence || "test@testmedefra.gov.uk"

  WasteExemptionsEngine::Registration.update_all(applicant_email: test_email, contact_email: test_email)
  WasteExemptionsEngine::TransientRegistration.update_all(applicant_email: test_email, contact_email: test_email)
end
