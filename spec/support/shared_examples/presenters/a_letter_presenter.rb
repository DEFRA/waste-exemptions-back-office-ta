# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a letter presenter" do
  let(:today) { Time.new(2019, 4, 2) }
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }

  describe "#contact_full_name" do
    it "returns the registration's contact first and last name attributes as a single string" do
      expected_name = "#{registration.contact_first_name} #{registration.contact_last_name}"

      expect(subject.contact_full_name).to eq(expected_name)
    end
  end

  describe "#date_of_letter" do
    before { Timecop.freeze(today) }
    after { Timecop.return }

    it "returns the current date formatted as for example '2 April 2019'" do
      expect(subject.date_of_letter).to eq("2 April 2019")
    end
  end

  describe "#human_business_type" do
    {
      sole_trader: "Individual or sole trader",
      limited_company: "Limited company",
      partnership: "Partnership",
      limited_liability_partnership: "Limited liability partnership",
      local_authority: "Local authority or public body",
      charity: "Charity or trust"
    }.each do |business_type, readable_result|
      context "when the registration's business_type is #{business_type}" do
        let(:registration) { create(:registration, business_type) }

        it "returns the human readable version" do
          expect(subject.human_business_type).to eq(readable_result)
        end
      end
    end
  end

  describe "#operator_address_one_liner" do
    it "returns a string representation of the address" do
      address = registration.operator_address
      expected_address = [
        address.premises,
        address.street_address,
        address.locality,
        address.city,
        address.postcode
      ].join(", ")

      expect(subject.operator_address_one_liner).to eq(expected_address)
    end
  end

  describe "#site_address_one_liner" do
    context "when the site location is located by grid reference" do
      it "returns an empty string" do
        expect(subject.site_address_one_liner).to eq("")
      end
    end

    context "when the site location is located by postcode" do
      let(:registration) { create(:registration, :site_uses_address) }
      it "returns a string representation of the address" do
        address = registration.site_address
        expected_address = [
          address.premises,
          address.street_address,
          address.locality,
          address.city,
          address.postcode
        ].join(", ")

        expect(subject.site_address_one_liner).to eq(expected_address)
      end
    end
  end
end
