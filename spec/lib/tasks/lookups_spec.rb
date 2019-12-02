# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Lookups task", type: :rake, vcr: true do
  include_context "rake"

  before { VCR.insert_cassette("valid_area_lookup", allow_playback_repeats: true) }
  after { VCR.eject_cassette }

  describe "lookups:update:missing_area" do

    before do
      allow(WasteExemptionsBackOffice::Application.config).to receive(:area_lookup_run_for).and_return(run_for)
    end

    let(:run_for) { 10 }

    it "updates the area for site addresses missing it, as long as x & y is populated" do
      site_address = create(:address, address_type: :site, x: 358_130.1, y: 172_687.87)
      non_site_address = create(:address, x: 358_130.1, y: 172_687.87)

      subject.invoke
      site_address.reload
      non_site_address.reload

      expect(site_address.area).to eq("Wessex")
      expect(non_site_address.area).to be_nil
    end
  end

  describe "lookups:update:missing_easting_and_northing" do
    before { VCR.insert_cassette("valid_postcode_lookup") }
    after { VCR.eject_cassette }

    before do
      expect(WasteExemptionsBackOffice::Application.config).to receive(:easting_and_northing_lookup_run_for).and_return(run_for)
    end

    let(:run_for) { 10 }

    it "updates x & y for site addresses missing them, as long as the postcode is populated" do
      site_address = create(:address, address_type: :site, x: nil, y: nil, postcode: "BS1 5AH")
      site_address_no_postcode = create(:address, address_type: :site, x: nil, y: nil, postcode: nil)
      non_site_address = create(:address, x: nil, y: nil, postcode: "BS1 5AH")

      # Expect no error
      expect(Airbrake).to_not receive(:notify)

      subject.invoke

      site_address.reload
      site_address_no_postcode.reload
      non_site_address.reload

      expect(site_address.x).to eq(358_205.03)
      expect(site_address.y).to eq(172_708.07)

      expect(site_address_no_postcode.x).to be_nil
      expect(site_address_no_postcode.y).to be_nil

      expect(non_site_address.x).to be_nil
      expect(non_site_address.y).to be_nil
    end
  end

end
