# frozen_string_literal: true

namespace :reports do
  namespace :generate do
    desc "Generate the bulk montly reports and upload them to S3."
    task bulk: :environment do
      Reports::BulkExportService.run

      Airbrake.close
    end

    desc "Generate the EPR report and upload it to S3."
    task epr: :environment do
      Reports::EprExportService.run

      Airbrake.close
    end
  end
end
