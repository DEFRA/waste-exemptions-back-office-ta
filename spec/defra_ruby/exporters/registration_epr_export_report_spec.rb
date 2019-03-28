# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRuby::Exporters::RegistrationEprExportReport do
  describe "#COLUMNS" do
    it "includes all of the headings required to generate the export" do
      actual_headers = described_class::COLUMNS.map { |h| h[:header] }
      expected_headers = %w[
        registration_number
        organisation_name
        organisation_premises
        organisation_street_address
        organisation_locality
        organisation_city
        organisation_postcode
        site_premises
        site_street_address
        site_locality
        site_city
        site_postcode
        site_country
        site_ngr
        site_easting
        site_northing
        exemption_code
        exemption_registration_date
        exemption_expiry_date
      ]
      expect(actual_headers).to match_array(expected_headers)
    end
  end

  describe "#query" do
    context "when there are multiple registrations with multiple exemptions" do
      let(:registrations) do
        [
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(7)),
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(3)),
          create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(5))
        ]
      end

      context "and all are active" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.activate(registration)
          end
        end

        it "returns the correct number of records" do
          expect(described_class.query.count).to eq(15)
        end
      end

      context "and some are inactive" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.activate(registration)
          end

          Helpers::Registrations.cease(registrations[0])
        end

        it "returns the correct number of records" do
          expect(described_class.query.count).to eq(8)
        end
      end

      context "and some are expired" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.activate(registration)
          end

          Helpers::Registrations.expire(registrations[1])
        end

        it "returns the correct number of records" do
          expect(described_class.query.count).to eq(12)
        end
      end

      context "and some are inactive or expired" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.activate(registration)
          end

          Helpers::Registrations.cease(registrations[1])
          Helpers::Registrations.expire(registrations[2])
        end

        it "returns the correct number of records" do
          expect(described_class.query.count).to eq(7)
        end
      end

      context "and all are expired" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.expire(registration)
          end
        end

        it "returns the correct number of records" do
          expect(described_class.query.count).to eq(0)
        end
      end
    end
  end
end
