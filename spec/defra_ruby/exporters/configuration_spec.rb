# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRuby::Exporters::Configuration do
  describe "ATTRIBUTES" do
    it "represents the expected config settings and only those settings" do
      expected_attributes = %i[
        batch_size
        aws_region
        epr_export_aws_credentials
        epr_export_s3_bucket
        epr_export_filename
        bulk_export_aws_credentials
        bulk_export_s3_bucket
        bulk_export_filename_base
        bulk_export_number_of_months
      ]
      expect(described_class::ATTRIBUTES).to match_array(expected_attributes)
    end
  end

  it "sets the appropriate default config settings" do
    fresh_config = described_class.new
    expect(fresh_config.batch_size).to eq(3000)
    expect(fresh_config.aws_region).to eq("eu-west-1")
    expect(fresh_config.bulk_export_number_of_months).to eq(1)

    unset_config = described_class::ATTRIBUTES.select { |a| fresh_config.public_send(a).nil? }
    expected_unset_config = described_class::ATTRIBUTES - %i[batch_size aws_region bulk_export_number_of_months]
    expect(unset_config).to match_array(expected_unset_config)
  end

  describe "#ensure_valid" do
    before(:each) do
      described_class::ATTRIBUTES.each do |attribute|
        subject.public_send("#{attribute}=", "foo")
      end
    end

    context "when all of the attributes are present" do
      it "does not raise an error" do
        expect { subject.ensure_valid }.to_not raise_error
        expect(subject.ensure_valid).to eq(true)
      end
    end

    context "when at least one of the attributes is missing" do
      before(:each) do
        subject.epr_export_s3_bucket = nil
      end

      it "raises an error" do
        message = "The following DefraRuby::Exporters configuration attributes are missing: [:epr_export_s3_bucket]"
        expect { subject.ensure_valid }.to raise_error(message)
      end
    end
  end
end
