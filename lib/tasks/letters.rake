# frozen_string_literal: true

namespace :letters do
  namespace :export do
    desc "Generate a bulk export PDF file of AD renewal letters expiring soon"
    task ad_renewals: :environment do
      expires_on = WasteExemptionsBackOffice::Application.config.ad_letters_exports_expires_in.to_i.days.from_now

      WasteExemptionsEngine::AdRenewalLettersExport.find_or_create_by(
        expires_on: expires_on
      ).export!

      older_than = WasteExemptionsBackOffice::Application.config.ad_letters_delete_records_in.to_i.weeks.from_now

      AdRenewalLettersExportCleanerService.run(older_than)

      Airbrake.close
    end
  end
end
