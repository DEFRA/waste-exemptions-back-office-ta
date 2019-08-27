# frozen_string_literal: true

namespace :cleanup do
  desc "Remove old transient_registrations from the database"
  task transient_registrations: :environment do
    TransientRegistrationCleanupService.run

    Airbrake.close
  end
end
