# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyConfirmationLetterPresenter do
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }

  describe "#date_registered" do
    it "returns the correct value" do
      expect(registration.registration_exemptions.first).to receive(:registered_on).and_return(Date.new(2020, 1, 1))
      expect(subject.date_registered).to eq("1 January 2020")
    end
  end

  describe "#applicant_name" do
    it "returns the correct value" do
      expect(subject.applicant_name).to eq("#{registration.applicant_first_name} #{registration.applicant_last_name}")
    end
  end

  describe "#contact_name" do
    it "returns the correct value" do
      expect(subject.contact_name).to eq("#{registration.contact_first_name} #{registration.contact_last_name}")
    end
  end

  describe "#business_details_section" do
    context "when the registration is a sole trader" do
      let(:registration) { create(:registration, :sole_trader, :with_active_exemptions) }

      it "returns an array with the correct data and labels" do
        address = registration.operator_address
        address_text = [
          address.organisation,
          address.premises,
          address.street_address,
          address.locality,
          address.city,
          address.postcode
        ].reject(&:blank?).join(", ")

        expected_array = [
          "Business or organisation type: Individual or sole trader",
          "Business or organisation name: #{registration.operator_name}",
          "Business or organisation address: #{address_text}"
        ]

        expect(subject.business_details_section).to eq(expected_array)
      end
    end

    context "when the registration is a partnership" do
      let(:registration) { create(:registration, :partnership, :with_active_exemptions) }

      it "returns an array with the correct data and labels" do
        first_partner = "#{registration.people.first.first_name} #{registration.people.first.last_name}"
        second_partner = "#{registration.people.last.first_name} #{registration.people.last.last_name}"
        address = registration.operator_address
        address_text = [
          address.organisation,
          address.premises,
          address.street_address,
          address.locality,
          address.city,
          address.postcode
        ].reject(&:blank?).join(", ")

        expected_array = [
          "Business or organisation type: Partnership",
          "Accountable partner 1: #{first_partner}",
          "Accountable partner 2: #{second_partner}",
          "Partnership address: #{address_text}"
        ]

        expect(subject.business_details_section).to eq(expected_array)
      end
    end

    context "when the registration is a limited company" do
      let(:registration) { create(:registration, :limited_company, :with_active_exemptions) }

      it "returns an array with the correct data and labels" do
        address = registration.operator_address
        address_text = [
          address.organisation,
          address.premises,
          address.street_address,
          address.locality,
          address.city,
          address.postcode
        ].reject(&:blank?).join(", ")

        expected_array = [
          "Business or organisation type: Limited company",
          "Registered name of the company: #{registration.operator_name}",
          "Registration number of the company: #{registration.company_no}",
          "Registered address of the company: #{address_text}"
        ]

        expect(subject.business_details_section).to eq(expected_array)
      end
    end
  end

  describe "#contact_details_section" do
    let(:registration) { create(:registration, :with_active_exemptions) }

    it "returns an array with the correct data and labels" do
      expected_array = [
        "Name: #{registration.contact_first_name} #{registration.contact_last_name}",
        "Telephone: #{registration.contact_phone}",
        "Email: #{registration.contact_email}"
      ]

      expect(subject.contact_details_section).to eq(expected_array)
    end

    context "when a contact position is specified" do
      let(:registration) { create(:registration, :with_active_exemptions, contact_position: "Head of Waste") }

      it "returns an array with the correct data and labels" do
        expected_array = [
          "Name: #{registration.contact_first_name} #{registration.contact_last_name}",
          "Position: Head of Waste",
          "Telephone: #{registration.contact_phone}",
          "Email: #{registration.contact_email}"
        ]

        expect(subject.contact_details_section).to eq(expected_array)
      end
    end
  end

  describe "#location_section" do
    context "when the site location is an address" do
      let(:registration) { create(:registration, :site_uses_address, :with_active_exemptions) }

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
          "Waste operation location: #{address_text}"
        ]

        expect(subject.location_section).to eq(expected_array)
      end
    end

    context "when the site location is a grid reference" do
      let(:registration) { create(:registration, :with_short_site_description, :with_active_exemptions) }

      it "returns an array with the correct data and labels" do
        expected_array = [
          "Grid reference: #{registration.site_address.grid_reference}",
          "Site details: #{registration.site_address.description}"
        ]

        expect(subject.location_section).to eq(expected_array)
      end
    end
  end

  describe "#exemptions_section" do
    let(:registration) { create(:registration, :with_active_exemptions) }

    before do
      allow_any_instance_of(WasteExemptionsEngine::RegistrationExemption).to receive(:expires_on).and_return(Date.new(2099, 1, 1))
    end

    it "returns an array with the correct exemptions" do
      expected_array = []
      registration.exemptions.each do |exemption|
        expected_array << "#{exemption.code}: #{exemption.summary} – Expires on 1 January 2099"
      end

      expect(subject.exemptions_section).to eq(expected_array)
    end

    context "when some exemptions are not active" do
      before do
        registration.registration_exemptions[1].update(state: "ceased")
        registration.registration_exemptions[2].update(state: "revoked")
      end

      it "only lists active exemptions" do
        active_exemption = registration.exemptions[0]
        expected_array = [
          "#{active_exemption.code}: #{active_exemption.summary} – Expires on 1 January 2099"
        ]

        expect(subject.exemptions_section).to eq(expected_array)
      end
    end
  end

  describe "#deregistered_exemptions_section" do
    let(:registration) { create(:registration, :with_active_exemptions) }

    before do
      allow_any_instance_of(WasteExemptionsEngine::RegistrationExemption).to receive(:deregistered_at).and_return(Date.new(2000, 1, 1))

      registration.registration_exemptions[1].update(state: "ceased")
      registration.registration_exemptions[2].update(state: "revoked")
    end

    it "only lists inactive exemptions" do
      ceased_exemption = registration.exemptions[1]
      revoked_exemption = registration.exemptions[2]
      expected_array = [
        "#{ceased_exemption.code}: #{ceased_exemption.summary} – Ceased on 1 January 2000",
        "#{revoked_exemption.code}: #{revoked_exemption.summary} – Revoked on 1 January 2000"
      ]

      expect(subject.deregistered_exemptions_section).to eq(expected_array)
    end
  end
end
