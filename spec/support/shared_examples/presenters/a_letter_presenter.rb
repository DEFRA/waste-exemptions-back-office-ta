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

  describe "#postal_address_lines" do
    it "returns an array with the contact name and address" do
      contact_name = "#{registration.contact_first_name} #{registration.contact_last_name}"
      address = registration.contact_address
      address_fields = [
        contact_name,
        registration.operator_name,
        address.organisation,
        address.premises,
        address.street_address,
        address.locality,
        address.city,
        address.postcode
      ].reject(&:blank?)

      expect(subject.postal_address_lines).to eq(address_fields)
    end
  end
end
