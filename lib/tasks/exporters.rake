# frozen_string_literal: true

require "defra_ruby/exporters/registration_export_service"

namespace :defra_ruby_exporters do
  desc "Generate the EPR CSV export and upload it to S3."
  task epr: :environment do
    DefraRuby::Exporters::RegistrationExportService.new.epr_export
  end
end
