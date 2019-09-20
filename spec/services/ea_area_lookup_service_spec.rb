# frozen_string_literal: true

require "rails_helper"

RSpec.describe EaAreaLookupService do
  describe ".run" do
    let(:address) { create(:address, x: 408602.61, y: 257535.31) }

    it "fetch the EA area corresponding to a x and y and update the address" do
      # Expect no error
      expect(Airbrake).to_not receive(:notify)

      expect { described_class.run(address) }.to change { address.reload.area }.from(nil).to("West Midlands")
    end
  end
end
