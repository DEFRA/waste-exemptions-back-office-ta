# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRuby::Exporters::RegistrationExportService, vcr: true do
  describe "EPR Export" do
    context "when there are multiple registrations with multiple exemptions" do
      let(:registrations) do
        [
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(7)),
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(3)),
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(5))
        ]
      end
      let(:epr_file_path) { Rails.root.join "tmp", "#{DefraRuby::Exporters.configuration.epr_export_filename}.csv" }
      let(:epr_report_class) { DefraRuby::Exporters::RegistrationEprExportReport }
      let(:bulk_report_class) { DefraRuby::Exporters::RegistrationBulkExportReport }

      before(:each) do
        registrations.each do |registration|
          Helpers::Registrations.activate(registration)
        end
      end

      after(:context) do
        file_path = Rails.root.join "tmp", "#{DefraRuby::Exporters.configuration.epr_export_filename}.csv"
        File.delete(file_path) if File.exist? file_path
      end

      describe "#epr_export" do
        before(:context) do
          epr_export_matcher = Helpers::VCR.save_export_matcher(
            ENV["AWS_DAILY_EXPORT_BUCKET"],
            DefraRuby::Exporters.configuration.epr_export_filename
          )
          VCR.insert_cassette(
            "save_epr_export_to_s3",
            match_requests_on: [:method, epr_export_matcher],
            allow_playback_repeats: true
          )
        end
        after(:context) do
          VCR.eject_cassette
        end
        it "calls #write_to_file with the correct parameters" do
          expect(described_class).to receive(:write_to_file).with(epr_report_class, epr_file_path)
          described_class.epr_export
        end

        it "calls #save_to_s3 with the correct parameters" do
          expect(described_class).to receive(:save_to_s3).with(:epr, epr_file_path).and_return(true)
          described_class.epr_export
        end

        it "deletes the file when it is finished" do
          expect(File).to receive(:delete).with(epr_file_path)
          described_class.epr_export
        end
      end

      describe "#bulk_export" do
        before(:context) do
          bulk_export_matcher = Helpers::VCR.save_export_matcher(
            ENV["AWS_BULK_EXPORT_BUCKET"],
            DefraRuby::Exporters.configuration.bulk_export_filename_base
          )
          VCR.insert_cassette(
            "save_bulk_export_to_s3",
            match_requests_on: [:method, bulk_export_matcher],
            allow_playback_repeats: true
          )

          VCR.insert_cassette("get_bulk_export_s3_bucket", allow_playback_repeats: true)
          VCR.insert_cassette("clear_bulk_export_s3_bucket", allow_playback_repeats: true)
        end
        after(:context) do
          3.times { VCR.eject_cassette }
        end

        def bulk_export_file_path(date_range_description)
          file_name = "#{DefraRuby::Exporters.configuration.bulk_export_filename_base}_#{date_range_description}.csv"
          Rails.root.join "tmp", file_name
        end

        context "when all of data fits within a single date range" do
          let(:date_range) { Date.new(2019, 3, 1)..Date.new(2019, 3, 31) }
          let(:bulk_file_path) do
            bulk_export_file_path(DefraRuby::Exporters::Helpers::DateRange.describe_date_range(date_range))
          end
          before(:each) do
            Helpers::Registrations.activate(registrations[0], Date.new(2019, 3, 3))
            Helpers::Registrations.activate(registrations[1], Date.new(2019, 3, 11))
            Helpers::Registrations.activate(registrations[2], Date.new(2019, 3, 7))
          end

          it "clears existing records" do
            expect(DefraRuby::Exporters::BulkExportFile).to receive(:destroy_all).once
            described_class.bulk_export
          end

          it "calls #write_to_file once with the correct parameters" do
            expect(described_class)
              .to receive(:write_to_file)
              .with(bulk_report_class, bulk_file_path, filter: { date_range: date_range })
              .once
            described_class.bulk_export
          end

          it "calls #save_to_s3 once with the correct parameters" do
            expect(described_class).to receive(:save_to_s3).with(:bulk, bulk_file_path).and_return(true).once
            described_class.bulk_export
          end

          it "saves a single link to the DB" do
            expect(DefraRuby::Exporters::BulkExportFile)
              .to receive(:create)
              .with(file_name: bulk_file_path.to_s.split("/").last)
              .once
            described_class.bulk_export
          end

          it "deletes one file when it is finished" do
            expect(File).to receive(:delete).with(bulk_file_path).once
            described_class.bulk_export
          end
        end

        context "when the data spans multiple date ranges" do
          let(:february) { Date.new(2019, 2, 1)..Date.new(2019, 2, 28) }
          let(:march) { Date.new(2019, 3, 1)..Date.new(2019, 3, 31) }
          let(:april) { Date.new(2019, 4, 1)..Date.new(2019, 4, 30) }
          let(:february_file_path) do
            bulk_export_file_path(DefraRuby::Exporters::Helpers::DateRange.describe_date_range(february))
          end
          let(:march_file_path) do
            bulk_export_file_path(DefraRuby::Exporters::Helpers::DateRange.describe_date_range(march))
          end
          let(:april_file_path) do
            bulk_export_file_path(DefraRuby::Exporters::Helpers::DateRange.describe_date_range(april))
          end
          before(:each) do
            Helpers::Registrations.activate(registrations[0], Date.new(2019, 2, 3))
            Helpers::Registrations.activate(registrations[1], Date.new(2019, 3, 11))
            Helpers::Registrations.activate(registrations[2], Date.new(2019, 4, 7))
          end

          it "clears existing records" do
            expect(DefraRuby::Exporters::BulkExportFile).to receive(:destroy_all).once
            described_class.bulk_export
          end

          it "calls #write_to_file multiple times with the correct parameters" do
            expect(described_class).to receive(:write_to_file).exactly(3).times
            described_class.bulk_export
          end

          it "calls #save_to_s3 multiple times with the correct parameters" do
            expect(described_class).to receive(:save_to_s3).exactly(3).times
            described_class.bulk_export
          end

          it "saves multiple files to the DB" do
            expect(DefraRuby::Exporters::BulkExportFile).to receive(:create).exactly(3).times
            described_class.bulk_export
          end

          it "deletes multiple files when it is finished" do
            expect(File).to receive(:delete).exactly(3).times
            described_class.bulk_export
          end
        end
      end

      describe "#write_to_file" do
        before(:context) do
          epr_export_matcher = Helpers::VCR.save_export_matcher(
            ENV["AWS_DAILY_EXPORT_BUCKET"],
            DefraRuby::Exporters.configuration.epr_export_filename
          )
          VCR.insert_cassette(
            "save_epr_export_to_s3",
            match_requests_on: [:method, epr_export_matcher],
            allow_playback_repeats: true
          )
        end
        after(:context) do
          VCR.eject_cassette
        end

        before(:each) do
          described_class.write_to_file(epr_report_class, epr_file_path)
        end

        it "creates a file that includes all expected records" do
          expect(CSV.parse(File.read(epr_file_path), headers: true).size).to eq(15)
        end

        it "creates a file that has columns which match those in the original view" do
          csv = CSV.parse(File.read(epr_file_path), headers: true)
          expected_headers = epr_report_class::COLUMNS.map { |h| h[:header] }

          expect(csv.headers).to match_array(expected_headers)
          # Make sure every line of the file has the correct number of columns.
          expect(csv.to_a.map(&:count).uniq).to eq([expected_headers.count])
        end
      end

      describe "#save_to_s3" do
        before(:context) do
          epr_export_matcher = Helpers::VCR.save_export_matcher(
            ENV["AWS_DAILY_EXPORT_BUCKET"],
            DefraRuby::Exporters.configuration.epr_export_filename
          )
          VCR.insert_cassette(
            "save_epr_export_to_s3",
            match_requests_on: [:method, epr_export_matcher],
            allow_playback_repeats: true
          )
        end
        after(:context) do
          VCR.eject_cassette
        end

        it "saves an exported file to s3" do
          described_class.write_to_file(epr_report_class, epr_file_path)
          expect(described_class.save_to_s3(:epr, epr_file_path)).to eq(true)
        end
      end

      describe "#presigned_url" do
        let(:file_name) do
          date_range = Date.new(2019, 3, 1)..Date.new(2019, 3, 31)
          date_range_description = DefraRuby::Exporters::Helpers::DateRange.describe_date_range(date_range)
          "#{DefraRuby::Exporters.configuration.bulk_export_filename_base}_#{date_range_description}.csv"
        end
        it "retrieves the presigned URL from S3" do
          url = described_class.presigned_url(:bulk, file_name)
          expect(url).to include(file_name)
          expect(url).to include(DefraRuby::Exporters.configuration.bulk_export_s3_bucket)
          expect(url).to include(DefraRuby::Exporters.configuration.aws_region)
          expect(url).to include("response-content-type=text%2Fcsv")
          expect(url).to include("X-Amz-Expires=1200")
          expect(url).to include("X-Amz-Credential=")
          expect(url).to include("X-Amz-Signature=")
        end
      end
    end
  end
end
