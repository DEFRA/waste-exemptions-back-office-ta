# frozen_string_literal: true

require_relative "../close_airbrake"

# rubocop:disable Metrics/BlockLength
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
      desc "Send first email reminder to all registrations expiring in X days (default is 28)"
      task send: :environment do
        return unless WasteExemptionsEngine::FeatureToggle.active?(:send_first_email_reminder)

        FirstRenewalReminderService.run

        CloseAirbrake.now
      end
    end

    namespace :second do
      desc "Send second email reminder to all registrations expiring in X days (default is 14)"
      task send: :environment do
        return unless WasteExemptionsEngine::FeatureToggle.active?(:send_second_email_reminder)

        SecondRenewalReminderService.run

        CloseAirbrake.now
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
