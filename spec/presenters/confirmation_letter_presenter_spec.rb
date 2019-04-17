# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConfirmationLetterPresenter do
  let(:registration) { create(:registration) }
  subject { described_class.new(registration) }

  describe "#date_of_letter" do
    it "returns the current date formatted as for example '3 April 2019'" do
      expected_value = Time.now.in_time_zone("London").to_date.to_formatted_s(:day_month_year)
      expect(subject.date_of_letter).to eq(expected_value)
    end
  end

  describe "#exemption_description" do
    let(:exemption) { build(:exemption) }

    it "returns a string representation formatted as 'code: summary'" do
      expect(subject.exemption_description(exemption)).to eq("#{exemption.code}: #{exemption.summary}")
    end
  end

  describe "#registration_exemption_status" do
    context "when the registration exemption is active" do
      let(:registration_exemption) { build(:registration_exemption, :active) }

      it "returns a string representation that states when the exemption will expire" do
        expected_status = "Expires on #{(Date.today + 3.years).to_formatted_s(:day_month_year)}"
        expect(subject.registration_exemption_status(registration_exemption)).to eq(expected_status)
      end
    end

    context "when the registration exemption is ceased" do
      let(:registration_exemption) { build(:registration_exemption, :ceased) }

      it "returns a string representation that states when the exemption was ceased" do
        expected_status = "Ceased on #{registration_exemption.deregistered_on.to_formatted_s(:day_month_year)}"
        expect(subject.registration_exemption_status(registration_exemption)).to eq(expected_status)
      end
    end

    context "when the registration exemption is revoked" do
      let(:registration_exemption) { build(:registration_exemption, :revoked) }

      it "returns a string representation that states when the exemption was revoked" do
        expected_status = "Revoked on #{registration_exemption.deregistered_on.to_formatted_s(:day_month_year)}"
        expect(subject.registration_exemption_status(registration_exemption)).to eq(expected_status)
      end
    end
  end
end
