# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRuby::Exporters::RegistrationExportService, vcr: true do
  describe "EPR Export" do
    context "when there are multiple registrations with multiple exemptions" do
      let(:temp_file) do
        # Using ruby's Tempfile library to create a unique temporary file in the
        # OS's temp folder, instead of creating something locally that we then
        # have to manage
        Tempfile.new(["wex_epr_export", ".csv"])
      end
      let(:registrations) do
        [
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(7)),
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(3))
        ]
      end
      let(:report_class) { DefraRuby::Exporters::RegistrationEprExportReport }

      before(:each) do
        registrations.each do |registration|
          Helpers::Registrations.activate(registration)
        end

        subject.write_to_file(report_class, temp_file.path)
      end

      after(:each) do
        # Ruby Tempfiles should automatically delete when the process that
        # created them finishes, but best practice to explicitly close them
        # http://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html#class-Tempfile-label-Explicit+close
        temp_file.close
        temp_file.unlink
      end

      describe "#write_to_file" do
        it "creates a file that includes all expected records" do
          expect(CSV.parse(File.read(temp_file.path), headers: true).size).to eq(10)
        end

        it "creates a file that has columns which match those in the original view" do
          csv = CSV.parse(File.read(temp_file.path), headers: true)
          expected_headers = report_class::COLUMNS.map { |h| h[:header] }

          expect(csv.headers).to match_array(expected_headers)
          # Make sure every line of the file has the correct number of columns.
          expect(csv.to_a.map(&:count).uniq).to eq([expected_headers.count])
        end
      end

      describe "#save_to_s3" do
        it "saves an exported file to s3" do
          # Tempfiles have unique names. However we need this test to work with VCR,
          # which will include the filename in its cassette. Therefore we have to
          # rename the tempfile to a fixed name so the cassette will match
          new_path = temp_file.path.sub(
            File.basename(temp_file.path),
            "waste_exemptions_epr_daily_full.csv"
          )

          File.rename(temp_file.path, new_path)

          subject.write_to_file(report_class, new_path)
          export_matcher = Helpers::VCR.export_matcher(ENV["AWS_DAILY_EXPORT_BUCKET"])
          VCR.use_cassette("save_epr_export_to_s3", match_requests_on: [:method, export_matcher]) do
            expect(subject.save_to_s3(:epr, new_path)).to eq(true)
          end
        end
      end
    end
  end
end
