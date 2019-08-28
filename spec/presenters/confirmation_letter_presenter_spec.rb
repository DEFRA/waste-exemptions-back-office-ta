# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConfirmationLetterPresenter do
  let(:today) { Time.new(2019, 4, 2) }
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }

  it_behaves_like "a letter presenter"

  describe "#submission_date" do
    before { Timecop.freeze(today) }
    after { Timecop.return }

    it "returns the registration's submitted_at date formatted as for example '2 April 2019'" do
      parsed_date = Date.parse(subject.submission_date)

      expect(parsed_date).to eq(registration.submitted_at)
    end
  end

  describe "#applicant_full_name" do
    it "returns the registration's applicant first and last name attributes as a single string" do
      expected_name = "#{registration.applicant_first_name} #{registration.applicant_last_name}"

      expect(subject.applicant_full_name).to eq(expected_name)
    end
  end

  describe "#partners" do
    let(:registration) { create(:registration, :partnership) }
    it "returns an array of hashes containing an incremented label and the partner's full name" do
      expected_result = registration.people.each_with_index.map do |person, index|
        { label: "Accountable partner #{index + 1}:", name: "#{person.first_name} #{person.last_name}" }
      end

      expect(subject.partners).to eq(expected_result)
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

    context "when the registration exemption is expired" do
      let(:registration_exemption) { build(:registration_exemption, :expired) }

      it "returns a string representation that states when the exemption was expired" do
        expect(subject.registration_exemption_status(registration_exemption)).to eq("Expired on 2 April 2022")
      end
    end
  end
end
