# frozen_string_literal: true

namespace :boxi_export do
  desc "Generates a Zip file containing data for BOXI export and load them to AWS bucket"
  task generate: :environment do
    BoxiExport::GeneratorService.run
  end
end
