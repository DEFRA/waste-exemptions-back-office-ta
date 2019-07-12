# frozen_string_literal: true

namespace :boxy_export do
  desc "Generates a Zip file containing data for BOXY export and load them to AWS bucket"
  task generate: :environment do
    BoxyExport::GeneratorService.run
  end
end
