# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConfirmationLetterPresenter do
  let(:registration) { create(:registration) }
  subject { described_class.new(registration) }

  describe "#exemption_description" do
    let(:exemption) { build(:exemption) }

    it "returns a string representation formatted as 'code: summary'" do
      expect(subject.exemption_description(exemption)).to eq("#{exemption.code}: #{exemption.summary}")
    end
  end
end
