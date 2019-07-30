# frozen_string_literal: true

namespace :email do
  desc "Send a test email to confirm setup is correct"
  task test: :environment do
    puts TestMailer.test_email.deliver_now
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
