# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationsHelper, type: :helper do
  let(:resource) { build(:new_registration) }

  describe "applicant_data_present?" do
    context "when the resource has data in at least one relevant field" do
      before { resource.applicant_first_name = "Foo" }

      it "returns true" do
        expect(helper.applicant_data_present?(resource)).to eq(true)
      end
    end

    context "when the resource does not have data in the relevant fields" do
      before do
        resource.applicant_first_name = nil
        resource.applicant_last_name = nil
        resource.applicant_phone = nil
        resource.applicant_email = nil
      end

      it "returns true" do
        expect(helper.applicant_data_present?(resource)).to eq(false)
      end
    end
  end

  describe "contact_data_present?" do
    context "when the resource has data in at least one relevant field" do
      before { resource.contact_first_name = "Foo" }

      it "returns true" do
        expect(helper.contact_data_present?(resource)).to eq(true)
      end
    end

    context "when the resource does not have data in the relevant fields" do
      before do
        resource.contact_first_name = nil
        resource.contact_last_name = nil
        resource.contact_phone = nil
        resource.contact_email = nil
        resource.contact_position = nil
      end

      it "returns true" do
        expect(helper.contact_data_present?(resource)).to eq(false)
      end
    end
  end
end
