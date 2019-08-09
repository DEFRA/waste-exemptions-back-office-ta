# frozen_string_literal: true

desc "Set all email addresses to given address or default one." \
      " Usage: `rake clean_emails TEST_EMAIL=test@testmedefra.gov.uk`"
task clean_emails: :environment do
  test_email = ENV["TEST_EMAIL"].presence || "test@testmedefra.gov.uk"

  WasteExemptionsEngine::Registration.update_all(applicant_email: test_email, contact_email: test_email)
  WasteExemptionsEngine::TransientRegistration.update_all(applicant_email: test_email, contact_email: test_email)
end
