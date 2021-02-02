# frozen_string_literal: true

namespace :notify do
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

      NotifyConfirmationLetterService.run(registration: registration)
    end
  end
end
