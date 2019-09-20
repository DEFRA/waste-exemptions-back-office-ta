# frozen_string_literal: true

namespace :ea_lookups do
  namespace :update do
    desc "Populate EA Area information in all WasteExemptionsEngine::Address objects missing it."
    task area: :environment do
      number_of_runs = WasteExemptionsBackOffice::Application.config.ea_area_lookup_number_of_runs
      addresses_scope = WasteExemptionsEngine::Address.missing_ea_area.with_easting_and_northing

      addresses_scope.limit(number_of_runs).each do |address|
        EaAreaLookupService.run(address)
      end

      Airbrake.close
    end
  end
end
