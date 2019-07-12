# frozen_string_literal: true

require "zip"
require_relative "../concerns/can_load_file_to_aws"

module BoxyExport
  class GeneratorService < ::WasteExemptionsEngine::BaseService
    include CanLoadFileToAws

    def run
      Dir.mktmpdir do |dir_path|
        generate_addresses_export(dir_path)
        generate_exemptions_export(dir_path)
        generate_people_export(dir_path)
        generate_registration_exemptions_export(dir_path)
        generate_registrations_export(dir_path)

        zip_export_files(dir_path)

        # load_file_to_aws_bucket
      end
    rescue StandardError => e
      Airbrake.notify e
      Rails.logger.error "Generate BOXY export error:\n#{e}"
    ensure
      File.unlink(file_path)
    end

    private

    def generate_addresses_export(dir_path)
      generate_export_file(
        File.join(dir_path, "addresses.csv"),
        BoxyExport::AddressesSerializer
      )
    end

    def generate_exemptions_export(dir_path)
      generate_export_file(
        File.join(dir_path, "exemptions.csv"),
        BoxyExport::ExemptionsSerializer
      )
    end

    def generate_people_export(dir_path)
      generate_export_file(
        File.join(dir_path, "people.csv"),
        BoxyExport::PeopleSerializer
      )
    end

    def generate_registration_exemptions_export(dir_path)
      generate_export_file(
        File.join(dir_path, "registration_exemptions.csv"),
        BoxyExport::RegistrationExemptionsSerializer
      )
    end

    def generate_registrations_export(dir_path)
      generate_export_file(
        File.join(dir_path, "registrations.csv"),
        BoxyExport::RegistrationsSerializer
      )
    end

    def generate_export_file(file_path, serializer_class)
      File.open(file_path, 'w') do |file|
        file.write serializer_class.new.to_csv
      end
    end

    def zip_export_files(dir_path)
      files_search_path = File.join(dir_path, "*.csv")

      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        Dir[files_search_path].each do |export_file_path|
          zipfile.add(File.basename(export_file_path), export_file_path)
        end
      end
    end

    def file_path
      @file_path ||= Rails.root.join("tmp/waste_exemptions_rep_daily_full.zip")
    end

    def bucket_name
      WasteExemptionsBackOffice::Application.config.boxy_exports_bucket_name
    end
  end
end
