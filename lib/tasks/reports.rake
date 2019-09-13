# frozen_string_literal: true

namespace :data do
  namespace :export do
    desc "Generate the bulk montly reports and upload them to S3."
    task bulk: :environment do
      Data::BulkExportService.run

      Airbrake.close
    end

    desc "Generate the EPR report and upload it to S3."
    task epr: :environment do
      Data::EprExportService.run

      Airbrake.close
    end

    desc "Generate the BOXI report (zipped) and upload it to S3."
    task boxi: :environment do
      Data::BoxiExportService.run if WasteExemptionsEngine::FeatureToggle.active?(:generate_boxi_report)

      Airbrake.close
    end
  end
end
