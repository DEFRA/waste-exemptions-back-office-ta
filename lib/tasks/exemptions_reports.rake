# frozen_string_literal: true

namespace :exemptions_reports do
  namespace :generate do
    desc "Generate the bulk montly reports and upload them to S3."
    task bulk: :environment do
      Reports::BulkExportService.run
    end
  end
end
