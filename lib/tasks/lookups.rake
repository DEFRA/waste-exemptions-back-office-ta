# frozen_string_literal: true

require_relative "../close_airbrake"
require_relative "../service_on_scope_runner"

namespace :lookups do
  namespace :update do
    desc "Update all sites with a missing area (x & y must be populated)"
    task missing_area: :environment do
      run_for = WasteExemptionsBackOffice::Application.config.area_lookup_run_for.to_i
      addresses_scope = WasteExemptionsEngine::Address.site.missing_area.with_easting_and_northing

      ServiceOnScopeRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: UpdateAreaService
      )

      Airbrake.close
    end

    desc "Populate EA Area information in all WasteExemptionsEngine::Address objects missing it."
    task missing_easting_and_northing: :environment do
      run_for = WasteExemptionsBackOffice::Application.config.easting_and_northing_lookup_run_for.to_i
      addresses_scope = WasteExemptionsEngine::Address.missing_easting_or_northing

      ServiceOnScopeRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: UpdateEastingAndNorthingService
      )

      CloseAirbrake.now
    end
  end
end
