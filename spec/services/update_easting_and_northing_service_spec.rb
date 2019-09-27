# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateEastingAndNorthingService do
  describe ".run" do
    context "when an error happens" do
      before { VCR.insert_cassette("valid_postcode_lookup") }
      after { VCR.eject_cassette }

      let(:address) { create(:address, postcode: "BS1 5AH", x: nil, y: nil) }

      it "notify rails loggers and Airbrake" do
        expect(address).to receive(:update_attributes!).and_raise("An error")

        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)

        described_class.run(address)
      end
    end

    context "When an address is located by grid reference" do
      before do
        # Expect no errors
        expect(Airbrake).to_not receive(:notify)
      end

      context "when the grid reference is valid" do
        let(:address) { create(:address, :site, grid_reference: "ST 58132 72695") }

        it "updates x and y to the correct information from OS places" do
          described_class.run(address)

          address.reload

          expect(address.x).to eq(358_132.0)
          expect(address.y).to eq(172_695.0)
        end
      end

      context "when the grid reference is invalid" do
        let(:address) { create(:address, :site, grid_reference: "AB 12345 23459") }

        it "updates x and y with 0.00" do
          described_class.run(address)

          address.reload

          expect(address.x).to eq(0.00)
          expect(address.y).to eq(0.00)
        end
      end
    end

    context "when an address is located by postcode" do
      before do
        # Expect no errors
        expect(Airbrake).to_not receive(:notify)
      end

      context "when the postcode is invalid" do
        before { VCR.insert_cassette("invalid_postcode_lookup") }
        after { VCR.eject_cassette }

        let(:address) { create(:address, postcode: "AB3 5EF", x: nil, y: nil) }

        it "sets the address easting and northing to 0.00" do
          described_class.run(address)

          address.reload

          expect(address.x).to eq(0.00)
          expect(address.y).to eq(0.00)
        end
      end

      context "when the postcode is valid" do
        before { VCR.insert_cassette("valid_postcode_lookup") }
        after { VCR.eject_cassette }

        let(:address) { create(:address, postcode: "BS1 5AH", x: nil, y: nil) }

        it "sets the address easting and northing to the value returned by the service" do
          described_class.run(address)

          address.reload

          expect(address.x).to eq(358_205.03)
          expect(address.y).to eq(172_708.07)
        end
      end

      context "when the lookup service is down" do
        let(:address) { create(:address, postcode: "BS1 5AH", x: 1.23, y: nil) }

        it "set up x and y to nil" do
          address_finder_service = double(:address_finder_service, search_by_postcode: :error)
          expect(WasteExemptionsEngine::AddressFinderService).to receive(:new).and_return(address_finder_service)

          described_class.run(address)

          expect(address.x).to be_nil
        end
      end
    end
  end
end
