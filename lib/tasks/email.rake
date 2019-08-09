# frozen_string_literal: true

namespace :email do
  desc "Send a test email to confirm setup is correct"
  task test: :environment do
    puts TestMailer.test_email.deliver_now
  end

  desc "Set all email domain addresses to given address or default one." \
      " Usage: `rake anonymise_emails ANONYMISE_EMAIL=test@testmedefra.gov.uk`"
  task anonymise: :environment do
    test_email = ENV["ANONYMISE_EMAIL"].presence || "test@example.com"

    WasteExemptionsEngine::Registration.update_all(applicant_email: test_email, contact_email: test_email)
    WasteExemptionsEngine::TransientRegistration.update_all(applicant_email: test_email, contact_email: test_email)
  end

  namespace :renew_reminder do
    namespace :first do
      desc "Collect all registration that expires in 4 weeks and sends an email reminder"
      task send: :environment do
        return unless WasteExemptionsEngine::FeatureToggle.active?(:send_first_email_reminder)

        FirstRenewalReminderService.run

        Airbrake.close
      end
    end
  end
end
