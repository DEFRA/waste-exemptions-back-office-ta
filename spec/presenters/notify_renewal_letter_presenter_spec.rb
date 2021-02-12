# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyRenewalLetterPresenter do
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }

  describe "#expiry_date" do
    it "returns the correct value" do
      expect(registration.registration_exemptions.first).to receive(:expires_on).and_return(Date.new(2020, 1, 1))
      expect(subject.expiry_date).to eq("1 January 2020")
    end
  end

  describe "#contact_name" do
    it "returns the correct value" do
      expect(subject.contact_name).to eq("#{registration.contact_first_name} #{registration.contact_last_name}")
    end
  end

  describe "#exemptions_text" do
    context "when there are 18 or fewer exemptions" do
      it "includes all exemptions" do
        expect(subject.exemptions_text.length).to eq(registration.exemptions.count)
        expect(subject.exemptions_text.first).to include(registration.exemptions.first.code)
        expect(subject.exemptions_text.last).to include(registration.exemptions.last.code)
      end
    end

    context "when there are more than 18 exemptions" do
      before do
        registration.exemptions = build_list(:exemption, 19)
      end

      it "only returns the first 18, with an abridged message" do
        expect(subject.exemptions_text.length).to eq(19)
        expect(subject.exemptions_text.first).to include(registration.exemptions.first.code)
        expect(subject.exemptions_text.last).to_not include(registration.exemptions.last.code)
        expect(subject.exemptions_text.last).to eq("You have 1 other exemption. Check your registration document to find it.")
      end
    end

    it "includes the active exemptions from the registration" do
      registration.registration_exemptions.first.update(state: :active)

      expect(subject.exemptions_text.first).to include(registration.exemptions.first.code)
    end

    it "includes the expired exemptions from the registration" do
      registration.registration_exemptions.first.update(state: :expired)

      expect(subject.exemptions_text.first).to include(registration.exemptions.first.code)
    end

    it "does not include revoked exemptions from the registration" do
      registration.registration_exemptions.first.update(state: :revoked)

      expect(subject.exemptions_text.first).to_not include(registration.exemptions.first.code)
    end

    it "does not include ceased exemptions from the registration" do
      registration.registration_exemptions.first.update(state: :ceased)

      expect(subject.exemptions_text.first).to_not include(registration.exemptions.first.code)
    end
  end

  describe "#business_details_section" do
    context "when the site location is an address" do
      context "when the registration is a sole trader" do
        let(:registration) { create(:registration, :site_uses_address, :sole_trader, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          address = registration.site_address
          address_text = [
            address.organisation,
            address.premises,
            address.street_address,
            address.locality,
            address.city,
            address.postcode
          ].reject(&:blank?).join(", ")

          expected_array = [
            "Type of business: Individual or sole trader",
            "Carrying out the waste operation: #{registration.operator_name}",
            "Location of waste operation: #{address_text}"
          ]

          expect(subject.business_details_section).to eq(expected_array)
        end
      end

      context "when the registration is a partnership" do
        let(:registration) { create(:registration, :site_uses_address, :partnership, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          first_partner = "#{registration.people.first.first_name} #{registration.people.first.last_name}"
          second_partner = "#{registration.people.last.first_name} #{registration.people.last.last_name}"
          address = registration.site_address
          address_text = [
            address.organisation,
            address.premises,
            address.street_address,
            address.locality,
            address.city,
            address.postcode
          ].reject(&:blank?).join(", ")

          expected_array = [
            "Type of business: Partnership",
            "Partners: #{first_partner}, #{second_partner}",
            "Location of waste operation: #{address_text}"
          ]

          expect(subject.business_details_section).to eq(expected_array)
        end
      end

      context "when the registration is a limited company" do
        let(:registration) { create(:registration, :site_uses_address, :limited_company, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          address = registration.site_address
          address_text = [
            address.organisation,
            address.premises,
            address.street_address,
            address.locality,
            address.city,
            address.postcode
          ].reject(&:blank?).join(", ")

          expected_array = [
            "Type of business: Limited company",
            "Company name: #{registration.operator_name}",
            "Company registration number: #{registration.company_no}",
            "Location of waste operation: #{address_text}"
          ]

          expect(subject.business_details_section).to eq(expected_array)
        end
      end
    end

    context "when the site location is a grid reference" do
      context "when the site description is under 200 characters" do
        let(:registration) { create(:registration, :with_short_site_description, :sole_trader, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          expected_array = [
            "Type of business: Individual or sole trader",
            "Carrying out the waste operation: #{registration.operator_name}",
            "Location of waste operation: #{registration.site_address.grid_reference}",
            "#{registration.site_address.description}"
          ]

          expect(subject.business_details_section).to eq(expected_array)
        end
      end

      context "when the site description is over 200 characters" do
        let(:registration) { create(:registration, :with_long_site_description, :sole_trader, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          truncated_site_description = registration.site_address.description.truncate(200, separator: " ")

          expected_array = [
            "Type of business: Individual or sole trader",
            "Carrying out the waste operation: #{registration.operator_name}",
            "Location of waste operation: #{registration.site_address.grid_reference}",
            "#{truncated_site_description}",
            "Check your registration document for the full site description."
          ]

          expect(subject.business_details_section).to eq(expected_array)
        end
      end
    end
  end
end
