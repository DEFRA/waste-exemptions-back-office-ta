# frozen_string_literal: true

require "rails_helper"

RSpec.describe EaAreaLookupService do
  describe ".run" do
    let(:address) { create(:address, x: 123.1, y: 123.1, area: nil) }
    let(:area) { "West Midlands" }

    before do
      expect(WasteExemptionsEngine::AreaLookupService).to receive(:run).and_return(area)
    end

    it "fetch the EA area corresponding to a x and y and update the address" do
      # Expect no error
      expect(Airbrake).to_not receive(:notify)

      expect { described_class.run(address) }.to change { address.reload.area }.from(nil).to(area)
    end

    context "when an error happens" do
      it "notify Airbrake and Rails" do
        expect(address).to receive(:update_attributes!).and_raise("Error")

        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)

        described_class.run(address)
      end
    end
  end
end
