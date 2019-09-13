# frozen_string_literal: true

require "rails_helper"

module Data
  RSpec.describe BoxiExportService do
    describe ".run" do
      let(:zip_file_path) { Rails.root.join("tmp/waste_exemptions_rep_daily_full.zip") }
      let(:bucket) { double(:bucket) }
      let(:aws_response) { double(:aws_response, successful?: true) }

      it "generates a zip file containing data for BOXI and load it to AWS" do
        # Cleanup before run
        File.delete(zip_file_path) if File.exist?(zip_file_path)

        # Intercept zip file deletion and block it
        allow(File).to receive(:unlink).and_call_original
        allow(File).to receive(:unlink).with(zip_file_path)

        # Expect file load to Aws bucket
        expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(bucket).to receive(:load).and_return(aws_response)

        # Expect no issues
        expect(Airbrake).to_not receive(:notify)

        expect { described_class.run }.to change { File.exist?(zip_file_path) }.from(false).to(true)

        Zip::File.open(zip_file_path) do |zip_file|
          all_entries = zip_file.entries.map(&:name)

          expect(all_entries).to include("people.csv")
          expect(all_entries).to include("exemptions.csv")
          expect(all_entries).to include("registration_exemptions.csv")
          expect(all_entries).to include("registrations.csv")
          expect(all_entries).to include("addresses.csv")
        end

        # Clean up after run
        File.delete(zip_file_path)
      end

      context "when an error happen" do
        it "logs the issue on Airbrake" do
          expect(Boxi::AddressesSerializer).to receive(:export_to_file).and_raise(StandardError)

          expect(Airbrake).to receive(:notify)

          described_class.run
        end
      end
    end
  end
end
