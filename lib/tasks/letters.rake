# frozen_string_literal: true

namespace :letters do
  namespace :export do
    desc "Generate a bulk export PDF file of AD renewal letters expiring soon"
    task ad_renewals: :environment do
      expires_on = WasteExemptionsBackOffice::Application.config.ad_letters_exports_expires_in.to_i.days.from_now

      WasteExemptionsEngine::AdRenewalLettersExport.find_or_create_by(
        expires_on: expires_on
      ).export!

      older_than = WasteExemptionsBackOffice::Application.config.ad_letters_delete_records_in.to_i.days.ago

      AdRenewalLettersExportCleanerService.run(older_than)

      # The test suite will complain about airbrake being closed already when running this
      # Since there is no way in version 5.8 to ask Airbrake if it is already closed or to
      # reopen it before every tets, this check will allow the test suite to not complain
      Airbrake.close unless Rails.env.test?
    end
  end
end
