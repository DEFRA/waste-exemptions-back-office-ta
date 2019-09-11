# frozen_string_literal: true

namespace :ad_renewal_letters do
  desc "Generate a bulk export PDF file of AD renewal letters expiring soon"
  task export: :environment do
    AdRenewalLettersExportService.run

    Airbrake.close
  end
end
