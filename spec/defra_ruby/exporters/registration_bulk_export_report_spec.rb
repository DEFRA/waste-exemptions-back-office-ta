# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRuby::Exporters::RegistrationBulkExportReport do
  describe ".columns" do
    it "includes all of the headings required to generate the export" do
      actual_headers = described_class.columns.map { |h| h[:header] }
      expected_headers = %w[
        reference_number
        registration_date
        applicant_first_name
        applicant_last_name
        applicant_phone_number
        applicant_email_address
        organisation_type
        company_reference_number
        organisation_name
        organisation_premises
        organisation_street_address
        organisation_locality
        organisation_city
        organisation_postcode
        correspondance_contact_first_name
        correspondance_contact_last_name
        correspondance_contact_position
        correspondance_contact_email_address
        correspondance_contact_phone_number
        correspondance_contact_premises
        correspondance_contact_street_address
        correspondance_contact_locality
        correspondance_contact_city
        correspondance_contact_postcode
        on_a_farm?
        is_a_farmer?
        site_premises
        site_street_address
        site_locality
        site_city
        site_postcode
        site_country
        site_location_grid_reference
        site_location_description
        exemption_code
        exemption_summary
        exemption_status
        exemption_valid_from_date
        exemption_expiry_date
        exemption_deregister_date
        exemption_deregister_comment
        assistance_type
      ]
      expect(actual_headers).to match_array(expected_headers)
    end
  end

  let(:registrations) do
    [
      create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(7)),
      create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(3)),
      create(:registration, exemptions: WasteExemptionsEngine::Exemption.first(5))
    ]
  end

  it "returns records ordered by their registration date ascending" do
    Helpers::Registrations.activate(registrations[0], Date.new(2019, 3, 3))
    Helpers::Registrations.activate(registrations[1], Date.new(2019, 3, 11))
    Helpers::Registrations.activate(registrations[2], Date.new(2019, 3, 7))

    query_reg_ids = described_class.query.each.map { |re| re.registration.id }
    expect(query_reg_ids.uniq).to eq([registrations[0].id, registrations[2].id, registrations[1].id])
  end

  describe ".query" do
    context "when there are multiple registrations with multiple exemptions" do
      context "and all are active" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.activate(registration)
          end
        end

        it "returns all records" do
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

        it "returns all records" do
          expect(described_class.query.count).to eq(15)
        end
      end

      context "and some are expired" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.activate(registration)
          end

          Helpers::Registrations.expire(registrations[1])
        end

        it "returns all records" do
          expect(described_class.query.count).to eq(15)
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

        it "returns all records" do
          expect(described_class.query.count).to eq(15)
        end
      end

      context "and all are expired" do
        before(:each) do
          registrations.each do |registration|
            Helpers::Registrations.expire(registration)
          end
        end

        it "returns all records" do
          expect(described_class.query.count).to eq(15)
        end
      end
    end
  end

  context "when a date range filter is given" do
    let(:filter) { { date_range: (Date.new(2019, 3, 1)..Date.new(2019, 3, 31)) } }

    context "and all of the registration exemptions were registered within the date range" do
      before(:each) do
        Helpers::Registrations.activate(registrations[0], Date.new(2019, 3, 3))
        Helpers::Registrations.activate(registrations[1], Date.new(2019, 3, 11))
        Helpers::Registrations.activate(registrations[2], Date.new(2019, 3, 7))
      end

      it "returns all records" do
        expect(described_class.query(filter).count).to eq(15)
      end
    end

    context "and some of the registration exemptions were registered within the date range" do
      before(:each) do
        Helpers::Registrations.activate(registrations[0], Date.new(2019, 2, 3))
        Helpers::Registrations.activate(registrations[1], Date.new(2019, 3, 11))
        Helpers::Registrations.activate(registrations[2], Date.new(2019, 4, 7))
      end

      it "returns the correct number of records" do
        expect(described_class.query(filter).count).to eq(3)
      end
    end

    context "and none of the registration exemptions were registered within the date range" do
      before(:each) do
        Helpers::Registrations.activate(registrations[0], Date.new(2019, 4, 3))
        Helpers::Registrations.activate(registrations[1], Date.new(2019, 4, 11))
        Helpers::Registrations.activate(registrations[2], Date.new(2019, 4, 7))
      end

      it "doesn't return any records" do
        expect(described_class.query(filter).count).to eq(0)
      end
    end
  end
end
