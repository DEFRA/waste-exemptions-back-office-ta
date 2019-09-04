# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalLetterPresenter do
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }

  it_behaves_like "a letter presenter"

  describe "#postal_address_lines" do
    context "when the registration is a sole trader" do
      let(:registration) { create(:registration, :sole_trader, :with_active_exemptions) }

      it "returns an array with the contact name and address" do
        contact_name = "#{registration.contact_first_name} #{registration.contact_last_name}"
        address = registration.contact_address
        address_fields = [
          contact_name,
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

    context "when the registration is not a sole trader" do
      let(:registration) { create(:registration, :limited_company, :with_active_exemptions) }

      it "returns an array with the contact name, operator name and address" do
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

  describe "#expiry_date" do
    it "returns the registration's expiry_date formatted as for example '2 April 2019'" do
      parsed_date = Date.parse(subject.expiry_date)

      expect(parsed_date).to eq(registration.registration_exemptions.first.expires_on)
    end
  end

  describe "#exemption_description" do
    it "returns the exemption code and summary in the correct format" do
      exemption = build(:exemption)
      string = "#{exemption.code} #{exemption.summary}"

      expect(subject.exemption_description(exemption)).to eq(string)
    end
  end

  describe "#listable_exemptions" do
    context "when there are 18 or fewer exemptions" do
      it "returns all exemptions" do
        expect(subject.listable_exemptions).to eq(registration.exemptions)
      end
    end

    context "when there are more than 18 exemptions" do
      before do
        registration.exemptions = build_list(:exemption, 19)
      end

      it "only returns the first 18" do
        expect(subject.listable_exemptions).to eq(registration.exemptions.first(18))
      end
    end

    it "includes the active exemptions from the registration" do
      registration.registration_exemptions.first.update_attributes(state: :active)

      expect(subject.listable_exemptions).to include(registration.exemptions.first)
    end

    it "includes the expired exemptions from the registration" do
      registration.registration_exemptions.first.update_attributes(state: :expired)

      expect(subject.listable_exemptions).to include(registration.exemptions.first)
    end

    it "does not include revoked exemptions from the registration" do
      registration.registration_exemptions.first.update_attributes(state: :revoked)

      expect(subject.listable_exemptions).to_not include(registration.exemptions.first)
    end

    it "does not include ceased exemptions from the registration" do
      registration.registration_exemptions.first.update_attributes(state: :ceased)

      expect(subject.listable_exemptions).to_not include(registration.exemptions.first)
    end
  end

  describe "#unlisted_exemption_count" do
    context "when there are 18 or fewer exemptions" do
      it "returns 0" do
        expect(subject.unlisted_exemption_count).to eq(0)
      end
    end

    context "when there are more than 18 exemptions" do
      before do
        registration.exemptions = build_list(:exemption, 19)
      end

      it "returns the count minus 18" do
        expect(subject.unlisted_exemption_count).to eq(1)
      end
    end
  end

  describe "#partners_list" do
    context "when the registration does not have partners" do
      let(:registration) { create(:registration, :sole_trader, :with_active_exemptions) }

      it "returns an empty string" do
        expect(subject.partners_list).to eq("")
      end
    end

    context "when the registration has partners" do
      let(:registration) { create(:registration, :partnership, :with_active_exemptions) }

      it "returns a comma-separated list of partners" do
        list = "#{registration.people.first.first_name} #{registration.people.first.last_name}, "\
               "#{registration.people.last.first_name} #{registration.people.last.last_name}"

        expect(subject.partners_list).to eq(list)
      end
    end
  end

  describe "#site_description" do
    context "when the description is under 200 characters" do
      let(:registration) { create(:registration, :with_active_exemptions, :with_short_site_description) }

      it "returns the site description" do
        expect(subject.site_description).to eq(registration.site_address.description)
      end
    end

    context "when the description is over 200 characters" do
      let(:registration) { create(:registration, :with_active_exemptions, :with_long_site_description) }

      it "abbreviates the site description to no more than 200 characters" do
        expect(subject.site_description.length).to be < 201
        expect(subject.site_description.last(3)).to eq("...")
      end
    end
  end

  describe "#site_description_abridged?" do
    context "when the description is under 200 characters" do
      let(:registration) { create(:registration, :with_active_exemptions, :with_short_site_description) }

      it "returns false" do
        expect(subject.site_description_abridged?).to be false
      end
    end

    context "when the description is over 200 characters" do
      let(:registration) { create(:registration, :with_active_exemptions, :with_long_site_description) }

      it "returns true" do
        expect(subject.site_description_abridged?).to be true
      end
    end
  end
end
