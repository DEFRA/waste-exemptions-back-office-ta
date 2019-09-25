# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Lookups task", type: :rake do
  include_context "rake"

  describe "lookups:update:missing_area" do
    before { VCR.insert_cassette("ea_area_lookups_west_midlands", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    before do
      allow(WasteExemptionsBackOffice::Application.config).to receive(:area_lookup_run_for).and_return(run_for)
    end

    let(:run_for) { 10 }

    it "update area info into addresses missing it" do
      site_address = create(:address, address_type: :site, x: 408_602.61, y: 257_535.31)
      non_site_address = create(:address, x: 408_602.61, y: 257_535.31)

      expect { subject.invoke }.to change { site_address.reload.area }.from(nil).to("West Midlands")
      expect { subject.invoke }.to_not change { non_site_address.reload.area }
    end
  end

  describe "lookups:update:missing_easting_and_northing" do
    before { VCR.insert_cassette("valid_postcode_lookup") }
    after { VCR.eject_cassette }

    before do
      expect(WasteExemptionsBackOffice::Application.config).to receive(:easting_and_northing_lookup_run_for).and_return(run_for)
    end

    let(:run_for) { 10 }

    it "update easting and northing info into addresses missing it" do
      address = create(:address, x: nil, y: nil, postcode: "BS1 5AH")

      subject.invoke

      address.reload

      expect(address.x).to eq(358_205.03)
      expect(address.y).to eq(172_708.07)
    end
  end

end
