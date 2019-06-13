# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe ExemptionBulkReportPresenter do
    let(:registration) { create(:registration) }
    let(:exemption) { create(:exemption) }
    let(:registered_on) { Date.today }

    let(:registration_exemption) do
      create(
        :registration_exemption,
        registration: registration,
        exemption: exemption,
        registered_on: registered_on
      )
    end

    subject(:exemption_bulk_report_presenter) { described_class.new(registration_exemption) }

    describe "#reference_number" do
      it "returns the correct registration reference number" do
        expect(exemption_bulk_report_presenter.reference_number).to eq(registration.reference)
      end
    end

    describe "#registration_date" do
      let(:registered_on) { Date.new(2019, 5, 29) }

      it "returns the registration date in the correct format" do
        expect(exemption_bulk_report_presenter.registration_date).to eq("2019-05-29")
      end
    end

    describe "#applicant_full_name" do
      let(:registration) { create(:registration, applicant_first_name: "Joe", applicant_last_name: "Black") }

      it "returns the applicant's full name" do
        expect(exemption_bulk_report_presenter.applicant_full_name).to eq("Joe Black")
      end
    end

    describe "#applicant_phone_number" do
      let(:registration) { create(:registration, applicant_phone: "07384923394") }

      it "returns the applicant's phone number" do
        expect(exemption_bulk_report_presenter.applicant_phone_number).to eq("07384923394")
      end
    end

    describe "#applicant_email_address" do
      let(:registration) { create(:registration, applicant_email: "joe-black@test.com") }

      it "returns the applicant's email address" do
        expect(exemption_bulk_report_presenter.applicant_email_address).to eq("joe-black@test.com")
      end
    end

    describe "#organisation_type" do
      let(:registration) { create(:registration, business_type: "limitedCompany") }

      it "returns the business type" do
        expect(exemption_bulk_report_presenter.organisation_type).to eq("limitedCompany")
      end
    end

    describe "#company_reference_number" do
      let(:registration) { create(:registration, company_no: "4934150") }

      it "returns the company's reference number" do
        expect(exemption_bulk_report_presenter.company_reference_number).to eq("4934150")
      end
    end

    describe "#organisation_name" do
      let(:registration) { create(:registration, operator_name: "My Awesome company") }

      it "returns the company's reference number" do
        expect(exemption_bulk_report_presenter.organisation_name).to eq("My Awesome company")
      end
    end

    describe "#organisation_address" do
      let(:organisation_address) do
        build(
          :address,
          :operator,
          organisation: "Park",
          premises: "Westland",
          street_address: "45 way",
          locality: "away",
          city: "Erabor",
          postcode: "HD5 JFS"
        )
      end

      let(:registration) { create(:registration, addresses: [organisation_address]) }

      it "returns the organisation address" do
        expect(exemption_bulk_report_presenter.organisation_address).to eq("Park, Westland, 45 way, away, Erabor, HD5 JFS")
      end
    end

    describe "#correspondance_contact_full_name" do
      let(:registration) { create(:registration, contact_first_name: "Joe", contact_last_name: "Black") }

      it "returns the contact full name" do
        expect(exemption_bulk_report_presenter.correspondance_contact_full_name).to eq("Joe Black")
      end
    end

    describe "#correspondance_contact_position" do
      let(:registration) { create(:registration, contact_position: "Manager") }

      it "returns the contact's position in the business" do
        expect(exemption_bulk_report_presenter.correspondance_contact_position).to eq("Manager")
      end
    end

    describe "#correspondance_contact_address" do
      let(:contact_address) do
        build(
          :address,
          :contact,
          organisation: "Park",
          premises: "Westland",
          street_address: "45 way",
          locality: "away",
          city: "Erabor",
          postcode: "HD5 JFS"
        )
      end

      let(:registration) { create(:registration, addresses: [contact_address]) }

      it "returns the contact's address" do
        expect(exemption_bulk_report_presenter.correspondance_contact_address).to eq("Park, Westland, 45 way, away, Erabor, HD5 JFS")
      end
    end

    describe "#correspondance_contact_email_address" do
      let(:registration) { create(:registration, contact_email: "joe-black@test.com") }

      it "returns the contact's email address" do
        expect(exemption_bulk_report_presenter.correspondance_contact_email_address).to eq("joe-black@test.com")
      end
    end

    describe "#on_a_farm?" do
      let(:registration) { create(:registration, on_a_farm: on_a_farm) }

      context "when on_a_farm attribute is true" do
        let(:on_a_farm) { true }

        it "return 'yes'" do
          expect(exemption_bulk_report_presenter.on_a_farm?).to eq("yes")
        end
      end

      context "when on_a_farm attribute is false" do
        let(:on_a_farm) { false }

        it "returns 'no'" do
          expect(exemption_bulk_report_presenter.on_a_farm?).to eq("no")
        end
      end
    end

    describe "#is_a_farmer?" do
      let(:registration) { create(:registration, is_a_farmer: is_a_farmer) }

      context "when is_a_farmer attribute is true" do
        let(:is_a_farmer) { true }

        it "return 'yes'" do
          expect(exemption_bulk_report_presenter.is_a_farmer?).to eq("yes")
        end
      end

      context "when is_a_farmer attribute is false" do
        let(:is_a_farmer) { false }

        it "returns 'no'" do
          expect(exemption_bulk_report_presenter.is_a_farmer?).to eq("no")
        end
      end
    end

    describe "#site_location_address" do
      let(:site_location_address) do
        build(
          :address,
          :site,
          organisation: "Park",
          premises: "Westland",
          street_address: "45 way",
          locality: "away",
          city: "Erabor",
          postcode: "HD5 JFS"
        )
      end

      let(:registration) { create(:registration, addresses: [site_location_address]) }

      it "returns the contact's address" do
        expect(exemption_bulk_report_presenter.site_location_address).to eq("Park, Westland, 45 way, away, Erabor, HD5 JFS")
      end

      context "if the address is located by grid reference" do
        let(:site_location_address) do
          build(
            :address,
            :site,
            mode: :auto
          )
        end

        it "returns nil" do
          expect(exemption_bulk_report_presenter.site_location_address).to be_nil
        end
      end
    end

    describe "#site_location_grid_reference" do
      let(:site_location_grid_reference) do
        build(
          :address,
          :site,
          grid_reference: "ST12345678"
        )
      end

      let(:registration) { create(:registration, addresses: [site_location_grid_reference]) }

      it "returns the contact's address" do
        expect(exemption_bulk_report_presenter.site_location_grid_reference).to eq("ST12345678")
      end
    end

    describe "#site_location_description" do
      let(:site_address) do
        build(
          :address,
          :site,
          description: "Next to the big green tree."
        )
      end

      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the contact's address" do
        expect(exemption_bulk_report_presenter.site_location_description).to eq("Next to the big green tree.")
      end
    end

    describe "#site_location_area" do
      let(:site_address) do
        build(
          :address,
          :site,
          area: "Site address area"
        )
      end

      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the site address area" do
        expect(exemption_bulk_report_presenter.site_location_area).to eq("Site address area")
      end
    end

    describe "#exemption_code" do
      let(:exemption) { create(:exemption, code: "G56") }

      it "returns the exemption's code" do
        expect(exemption_bulk_report_presenter.exemption_code).to eq("G56")
      end
    end

    describe "#exemption_summary" do
      let(:exemption) { create(:exemption, summary: "I exempt you from waste!") }

      it "returns the exemption's code" do
        expect(exemption_bulk_report_presenter.exemption_summary).to eq("I exempt you from waste!")
      end
    end

    describe "#exemption_status" do
      let(:registration_exemption) { create(:registration_exemption, state: "active") }

      it "returns the exemption's state" do
        expect(exemption_bulk_report_presenter.exemption_status).to eq("active")
      end
    end

    describe "#exemption_valid_from_date" do
      let(:registered_on) { Date.new(2019, 5, 29) }

      it "returns the exemption's registered on date" do
        expect(exemption_bulk_report_presenter.exemption_valid_from_date).to eq("2019-05-29")
      end
    end

    describe "#exemption_expiry_date" do
      let(:registration_exemption) { create(:registration_exemption, expires_on: Date.new(2022, 5, 28)) }

      it "returns the exemption's expiry date" do
        expect(exemption_bulk_report_presenter.exemption_expiry_date).to eq("2022-05-28")
      end
    end

    describe "#exemption_deregister_date" do
      let(:registration_exemption) { create(:registration_exemption, deregistered_at: Date.new(2019, 5, 29)) }

      it "returns the deregistered at exemption's date" do
        expect(exemption_bulk_report_presenter.exemption_deregister_date).to eq("2019-05-29")
      end
    end

    describe "#exemption_deregister_comment" do
      let(:registration_exemption) { create(:registration_exemption, deregistration_message: "I didn't like that farmer.") }

      it "returns the deregistered exemption's comment" do
        expect(exemption_bulk_report_presenter.exemption_deregister_comment).to eq("I didn't like that farmer.")
      end
    end

    describe "#assistance_type" do
      let(:registration) { create(:registration, assistance_mode: assistance_mode) }

      context "when assistance_mode is blank" do
        let(:assistance_mode) { nil }

        it "returns the string 'unassisted'" do
          expect(exemption_bulk_report_presenter.assistance_type).to eq("unassisted")
        end
      end

      context "when assistance_mode is set to 'full'" do
        let(:assistance_mode) { "full" }

        it "returns the string 'fully assisted'" do
          expect(exemption_bulk_report_presenter.assistance_type).to eq("fully assisted")
        end
      end
    end

    describe "#registration_detail_url" do
      it "returns an url to the registration details backend page" do
        url = "http://localhost:8001/registrations/#{registration.reference}"

        expect(exemption_bulk_report_presenter.registration_detail_url).to eq(url)
      end
    end
  end
end
