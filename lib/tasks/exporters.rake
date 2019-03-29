# frozen_string_literal: true

require "defra_ruby/exporters/registration_export_service"

namespace :defra_ruby_exporters do
  desc "Generate the EPR CSV export and upload it to S3."
  task epr: :environment do
    DefraRuby::Exporters::RegistrationExportService.epr_export
  end

  desc "Generate the bluk CSV exports and upload them to S3."
  task bulk: :environment do
    DefraRuby::Exporters::RegistrationExportService.bulk_export
  end
end
