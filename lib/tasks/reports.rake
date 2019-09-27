# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Generate the bulk montly reports and upload them to S3."
    task bulk: :environment do
      Reports::BulkExportService.run

      # The test suite will complain about airbrake being closed already when running this
      # Since there is no way in version 5.8 to ask Airbrake if it is already closed or to
      # reopen it before every tets, this check will allow the test suite to not complain
      Airbrake.close unless Rails.env.test?
    end

    desc "Generate the EPR report and upload it to S3."
    task epr: :environment do
      Reports::EprExportService.run

      # The test suite will complain about airbrake being closed already when running this
      # Since there is no way in version 5.8 to ask Airbrake if it is already closed or to
      # reopen it before every tets, this check will allow the test suite to not complain
      Airbrake.close unless Rails.env.test?
    end

    desc "Generate the BOXI report (zipped) and upload it to S3."
    task boxi: :environment do
      Reports::BoxiExportService.run if WasteExemptionsEngine::FeatureToggle.active?(:generate_boxi_report)

      # The test suite will complain about airbrake being closed already when running this
      # Since there is no way in version 5.8 to ask Airbrake if it is already closed or to
      # reopen it before every tets, this check will allow the test suite to not complain
      Airbrake.close unless Rails.env.test?
    end
  end
end
