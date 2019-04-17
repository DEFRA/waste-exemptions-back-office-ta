# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConfirmationLetterPresenter do
  let(:today) { Time.new(2019, 4, 2).in_time_zone("London") }
  let(:registration) { create(:registration) }
  subject { described_class.new(registration) }

  describe "#web_page_title" do
    it "returns the title including the registration reference" do
      expect(subject.web_page_title).to eq("Waste Exemptions confirmation letter for #{registration.reference}")
    end
  end

  describe "#date_of_letter" do
    before { Timecop.freeze(today) }
    after { Timecop.return }

    it "returns the current date formatted as for example '3 April 2019'" do
      expect(subject.date_of_letter).to eq("2 April 2019")
    end
  end

  describe "#exemption_description" do
    let(:exemption) { build(:exemption) }

    it "returns a string representation formatted as 'code: summary'" do
      expect(subject.exemption_description(exemption)).to eq("#{exemption.code}: #{exemption.summary}")
    end
  end

  describe "#registration_exemption_status" do
    before { Timecop.freeze(today) }
    after { Timecop.return }

    context "when the registration exemption is active" do
      let(:registration_exemption) { build(:registration_exemption, :active) }

      it "returns a string representation that states when the exemption will expire" do
        expect(subject.registration_exemption_status(registration_exemption)).to eq("Expires on 2 April 2022")
      end
    end

    context "when the registration exemption is ceased" do
      let(:registration_exemption) { build(:registration_exemption, :ceased) }

      it "returns a string representation that states when the exemption was ceased" do
        expect(subject.registration_exemption_status(registration_exemption)).to eq("Ceased on 1 April 2019")
      end
    end

    context "when the registration exemption is revoked" do
      let(:registration_exemption) { build(:registration_exemption, :revoked) }

      it "returns a string representation that states when the exemption was revoked" do
        expect(subject.registration_exemption_status(registration_exemption)).to eq("Revoked on 1 April 2019")
      end
    end
  end
end
