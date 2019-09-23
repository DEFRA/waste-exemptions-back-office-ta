# frozen_string_literal: true

namespace :lookups do
  namespace :update do
    desc "Populate EA Area information in all WasteExemptionsEngine::Address objects missing it."
    task missing_area: :environment do
      run_for = WasteExemptionsBackOffice::Application.config.area_lookup_run_for.to_i
      run_until = run_for.minutes.from_now
      addresses_scope = WasteExemptionsEngine::Address.missing_ea_area.with_easting_and_northing

      addresses_scope.find_each do |address|
        break if Time.now > run_until

        EaAreaLookupService.run(address)
      end

      Airbrake.close
    end
  end
end
