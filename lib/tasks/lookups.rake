# frozen_string_literal: true

require_relative "../close_airbrake"
require_relative "../service_on_scope_runner"

namespace :lookups do
  namespace :update do
    desc "Update all sites with a missing area (x & y must be populated)"
    task missing_area: :environment do
      run_for = WasteExemptionsBackOffice::Application.config.area_lookup_run_for.to_i
      addresses_scope = WasteExemptionsEngine::Address.site.missing_area.with_easting_and_northing

      TimedServiceRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: UpdateAreaService
      )

      # The test suite will complain about airbrake being closed already when running this
      # Since there is no way in version 5.8 to ask Airbrake if it is already closed or to
      # reopen it before every tets, this check will allow the test suite to not complain
      Airbrake.close unless Rails.env.test?
    end

    desc "Populate EA Area information in all WasteExemptionsEngine::Address objects missing it."
    task missing_easting_and_northing: :environment do
      run_for = WasteExemptionsBackOffice::Application.config.easting_and_northing_lookup_run_for.to_i
      addresses_scope = WasteExemptionsEngine::Address.site.missing_easting_or_northing

      TimedServiceRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: UpdateEastingAndNorthingService
      )

      CloseAirbrake.now
    end
  end
end
