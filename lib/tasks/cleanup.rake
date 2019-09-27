# frozen_string_literal: true

require_relative "../close_airbrake"

namespace :cleanup do
  desc "Remove old transient_registrations from the database"
  task transient_registrations: :environment do
    TransientRegistrationCleanupService.run

    CloseAirbrake.now
  end
end
