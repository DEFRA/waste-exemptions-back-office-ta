# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :notify do
  namespace :letters do
    desc "List all registrations which will receive the renewal letter"
    task ad_renewals: :environment do
      expires_on = WasteExemptionsBackOffice::Application.config.ad_letters_exports_expires_in.to_i.days.from_now

      registrations = BulkNotifyRenewalLettersService.run(expires_on)

      if registrations.any?
        puts registrations
      else
        puts "No matching registrations"
      end
    end
  end

  namespace :test do
    desc "Send a test first renewal reminder email to the newest registration in the DB"
    task first_renewal_reminder: :environment do
      registration = WasteExemptionsEngine::Registration.last

      FirstRenewalReminderEmailService.run(registration: registration)
    end

    desc "Send a test second renewal reminder email to the newest registration in the DB"
    task second_renewal_reminder: :environment do
      registration = WasteExemptionsEngine::Registration.last

      SecondRenewalReminderEmailService.run(registration: registration)
    end

    desc "Send a test confirmation letter to the newest registration in the DB"
    task ad_confirmation_letter: :environment do
      registration = WasteExemptionsEngine::Registration.last

      WasteExemptionsEngine::NotifyConfirmationLetterService.run(registration: registration)
    end

    desc "Send a test renewal letter to the newest registration in the DB"
    task ad_renewal_letter: :environment do
      registration = WasteExemptionsEngine::Registration.last

      NotifyRenewalLetterService.run(registration: registration)
    end
  end
end
# rubocop:enable Metrics/BlockLength
