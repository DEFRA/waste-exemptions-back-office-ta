# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do
  describe "preselect_registrations_radio_button?" do
    context "when @filter is blank" do
      it "returns true" do
        expect(helper.preselect_registrations_radio_button?).to eq(true)
      end
    end

    context "when @filter is set to :registrations" do
      before { assign(:filter, :registrations) }

      it "returns true" do
        expect(helper.preselect_registrations_radio_button?).to eq(true)
      end
    end

    context "when @filter is set to :transient_registrations" do
      before { assign(:filter, :transient_registrations) }

      it "returns false" do
        expect(helper.preselect_registrations_radio_button?).to eq(false)
      end
    end
  end

  describe "preselect_transient_registrations_radio_button?" do
    context "when @filter is blank" do
      it "returns false" do
        expect(helper.preselect_transient_registrations_radio_button?).to eq(false)
      end
    end

    context "when @filter is set to :registrations" do
      before { assign(:filter, :registrations) }

      it "returns false" do
        expect(helper.preselect_transient_registrations_radio_button?).to eq(false)
      end
    end

    context "when @filter is set to :transient_registrations" do
      before { assign(:filter, :transient_registrations) }

      it "returns true" do
        expect(helper.preselect_transient_registrations_radio_button?).to eq(true)
      end
    end
  end
end
