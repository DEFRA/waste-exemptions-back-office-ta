# frozen_string_literal: true

namespace :notify do
  namespace :test do
    desc "Send a test first renewal reminder email to the newest registration in the DB"
    task first_renewal_reminder: :environment do
      registration = WasteExemptionsEngine::Registration.last
      recipient = registration.contact_email

      FirstRenewalReminderEmailService.run(registration: registration, recipient: recipient)
    end
  end
end
