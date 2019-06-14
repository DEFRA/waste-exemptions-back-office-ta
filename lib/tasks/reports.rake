# frozen_string_literal: true

namespace :reports do
  namespace :generate do
    desc "Generate the bulk montly reports and upload them to S3."
    task bulk: :environment do
      Reports::BulkExportService.run
    end

    desc "Generate the EPR reports and upload them to S3."
    task epr: :environment do
      Reports::EprExportService.run
    end
  end
end
