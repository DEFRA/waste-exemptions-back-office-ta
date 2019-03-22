# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRuby::Exporters::RegistrationExportService, vcr: true do
  describe "EPR Export" do
    context "when there are multiple registrations with multiple exemptions" do
      let(:registrations) do
        [
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(7)),
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(3))
        ]
      end
      let(:file_path) { Rails.root.join "tmp", DefraRuby::Exporters::EPR_EXPORT_FILENAME }
      let(:report_class) { DefraRuby::Exporters::RegistrationEprExportReport }

      before(:each) do
        registrations.each do |registration|
          Helpers::Registrations.activate(registration)
        end
      end

      before(:context) do
        export_matcher = Helpers::VCR.export_matcher(ENV["AWS_DAILY_EXPORT_BUCKET"])
        VCR.insert_cassette(
          "save_epr_export_to_s3",
          match_requests_on: [:method, export_matcher],
          allow_playback_repeats: true
        )
      end
      after(:context) do
        file_path = Rails.root.join "tmp", DefraRuby::Exporters::EPR_EXPORT_FILENAME
        File.delete(file_path) if File.exist? file_path
        VCR.eject_cassette
      end

      describe "#epr_export" do
        it "calls #write_to_file with the correct parameters" do
          expect(subject).to receive(:write_to_file).with(report_class, file_path)
          subject.epr_export
        end

        it "calls #save_to_s3 with the correct parameters" do
          expect(subject).to receive(:save_to_s3).with(:epr, file_path).and_return(true)
          subject.epr_export
        end

        it "deletes the file when it is finished" do
          expect(File).to receive(:delete).with(file_path)
          subject.epr_export
        end
      end

      describe "#write_to_file" do
        before(:each) do
          subject.write_to_file(report_class, file_path)
        end

        it "creates a file that includes all expected records" do
          expect(CSV.parse(File.read(file_path), headers: true).size).to eq(10)
        end

        it "creates a file that has columns which match those in the original view" do
          csv = CSV.parse(File.read(file_path), headers: true)
          expected_headers = report_class::COLUMNS.map { |h| h[:header] }

          expect(csv.headers).to match_array(expected_headers)
          # Make sure every line of the file has the correct number of columns.
          expect(csv.to_a.map(&:count).uniq).to eq([expected_headers.count])
        end
      end

      describe "#save_to_s3" do
        it "saves an exported file to s3" do
          subject.write_to_file(report_class, file_path)
          expect(subject.save_to_s3(:epr, file_path)).to eq(true)
        end
      end
    end
  end
end
