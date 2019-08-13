# frozen_string_literal: true

namespace :reminder do
  desc "Send an example first renewal email"
  task first: :environment do
    registration = WasteExemptionsEngine::Registration.last
    RenewalReminderMailer.first_reminder_email(registration).deliver_now
  end

  desc "Send an example second renewal email"
  task second: :environment do
    registration = WasteExemptionsEngine::Registration.last
    RenewalReminderMailer.second_reminder_email(registration).deliver_now
  end

  desc "Send an example first magic link email"
  task magic_link: :environment do
    registration = WasteExemptionsEngine::Registration.last
    RenewalReminderMailer.first_renew_with_magic_link_email(registration).deliver_now
  end
end
