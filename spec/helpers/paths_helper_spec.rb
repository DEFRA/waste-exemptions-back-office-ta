# frozen_string_literal: true

require "rails_helper"

RSpec.describe PathsHelper, type: :helper do
  describe "view_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq(registration_path(resource.reference))
      end
    end

    context "when the resource is a transient_registration" do
      let(:resource) { create(:transient_registration) }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq(transient_registration_path(resource.reference))
      end
    end

    context "when the resource is not a registration or a transient_registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq("#")
      end
    end
  end
end
