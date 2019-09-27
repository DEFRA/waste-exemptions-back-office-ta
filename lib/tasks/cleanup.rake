# frozen_string_literal: true

namespace :cleanup do
  desc "Remove old transient_registrations from the database"
  task transient_registrations: :environment do
    TransientRegistrationCleanupService.run

    # The test suite will complain about airbrake being closed already when running this
    # Since there is no way in version 5.8 to ask Airbrake if it is already closed or to
    # reopen it before every tets, this check will allow the test suite to not complain
    Airbrake.close unless Rails.env.test?
  end
end
