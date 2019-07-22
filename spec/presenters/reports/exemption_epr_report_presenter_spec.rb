# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe ExemptionEprReportPresenter do
    let(:registration) { create(:registration) }
    let(:exemption) { create(:exemption) }
    let(:registration_exemption) do
      create(
        :registration_exemption,
        registration: registration,
        exemption: exemption
      )
    end

    subject(:presenter) { described_class.new(registration_exemption) }

    describe "#registration_number" do
      let(:registration) { create(:registration) }

      it "returns the registration reference" do
        expect(presenter.registration_number).to eq(registration.reference)
      end
    end

    describe "#organisation_name" do
      let(:registration) { create(:registration, operator_name: "Awesome stuff") }

      it "rerturns the registration operator name" do
        expect(presenter.organisation_name).to eq("Awesome stuff")
      end
    end

    describe "#organisation_premises" do
      let(:operator_address) { create(:address, :operator, premises: "123 ABC") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address premises" do
        expect(presenter.organisation_premises).to eq("123 ABC")
      end

      context "if the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_premises).to be_nil
        end
      end
    end

    describe "#organisation_street_address" do
      let(:operator_address) { create(:address, :operator, street_address: "32 Foo St") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator street address" do
        expect(presenter.organisation_street_address).to eq("32 Foo St")
      end

      context "if the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_street_address).to be_nil
        end
      end
    end

    describe "#organisation_locality" do
      let(:operator_address) { create(:address, :operator, locality: "Avon") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address locality" do
        expect(presenter.organisation_locality).to eq("Avon")
      end

      context "if the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_street_address).to be_nil
        end
      end
    end

    describe "#organisation_city" do
      let(:operator_address) { create(:address, :operator, city: "Bristol") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address city" do
        expect(presenter.organisation_city).to eq("Bristol")
      end

      context "if the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_city).to be_nil
        end
      end
    end

    describe "#organisation_postcode" do
      let(:operator_address) { create(:address, :operator, postcode: "BS1 4RE") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address postcode" do
        expect(presenter.organisation_postcode).to eq("BS1 4RE")
      end
    end

    describe "#site_premises" do
      let(:site_address) { create(:address, :site, premises: "Bar 123") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address premises" do
        expect(presenter.site_premises).to eq("Bar 123")
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_premises).to be_nil
        end
      end
    end

    describe "#site_street_address" do
      let(:site_address) { create(:address, :site, street_address: "12 Baz road") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address street" do
        expect(presenter.site_street_address).to eq("12 Baz road")
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_street_address).to be_nil
        end
      end
    end

    describe "#site_locality" do
      let(:site_address) { create(:address, :site, locality: "Avon") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address locality" do
        expect(presenter.site_locality).to eq("Avon")
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_locality).to be_nil
        end
      end
    end

    describe "#site_city" do
      let(:site_address) { create(:address, :site, city: "Bristol") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address locality" do
        expect(presenter.site_city).to eq("Bristol")
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_city).to be_nil
        end
      end
    end

    describe "#site_postcode" do
      let(:site_address) { create(:address, :site, postcode: "BS2 34G") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address postcode" do
        expect(presenter.site_postcode).to eq("BS2 34G")
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_postcode).to be_nil
        end
      end
    end

    describe "#site_country" do
      let(:site_address) { create(:address, :site, country_iso: "GB") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address country" do
        expect(presenter.site_country).to eq("GB")
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_country).to be_nil
        end
      end
    end

    describe "#site_ngr" do
      let(:site_address) { create(:address, :site, grid_reference: "SB1234") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address grid reference" do
        expect(presenter.site_ngr).to eq("SB1234")
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_ngr).to be_nil
        end
      end
    end

    describe "#site_easting" do
      let(:site_address) { create(:address, :site, x: "123.45") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address x coordinates" do
        expect(presenter.site_easting).to eq(123.45)
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_easting).to be_nil
        end
      end
    end

    describe "#site_northing" do
      let(:site_address) { create(:address, :site, y: "123.45") }
      let(:registration) { create(:registration, addresses: [site_address]) }

      it "returns the operator address y coordinates" do
        expect(presenter.site_northing).to eq(123.45)
      end

      context "if the registration has no site address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.site_northing).to be_nil
        end
      end
    end

    describe "#exemption_code" do
      let(:exemption) { create(:exemption, code: "G12") }

      it "returns the exemption code" do
        expect(presenter.exemption_code).to eq("G12")
      end
    end

    describe "#exemption_registration_date" do
      let(:registration_exemption) { create(:registration_exemption, registered_on: Date.new(2019, 6, 1)) }

      it "returns the registered on date formatted" do
        expect(presenter.exemption_registration_date).to eq("2019-06-01")
      end
    end

    describe "#exemption_expiry_date" do
      let(:registration_exemption) { create(:registration_exemption, expires_on: Date.new(2019, 6, 1)) }

      it "returns the registered on date formatted" do
        expect(presenter.exemption_expiry_date).to eq("2019-06-01")
      end
    end
  end
end
