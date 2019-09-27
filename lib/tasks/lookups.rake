# frozen_string_literal: true

require_relative "../close_airbrake"

namespace :lookups do
  namespace :update do
    desc "Update all sites with a missing area (x & y must be populated)"
    task missing_area: :environment do
      run_for = WasteExemptionsBackOffice::Application.config.area_lookup_run_for.to_i
      run_until = run_for.minutes.from_now
      addresses_scope = WasteExemptionsEngine::Address.site.missing_area.with_easting_and_northing

      addresses_scope.find_each do |address|
        break if Time.now > run_until

        UpdateAreaService.run(address)
      end

      CloseAirbrake.now
    end
  end
end
