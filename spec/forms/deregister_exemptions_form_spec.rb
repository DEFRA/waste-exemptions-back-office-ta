# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregisterExemptionsForm, type: :model do
  subject(:form) { described_class.new }

  describe "validations" do
    subject(:validators) { form._validators }

    it "validates the new state using the DeregistrationStateTransitionValidator class" do
      expect(validators.keys).to include(:state_transition)
      expect(validators[:state_transition].first.class)
        .to eq(DeregistrationStateTransitionValidator)
    end

    it "validates the message using the DeregistrationMessageValidator class" do
      expect(validators.keys).to include(:message)
      expect(validators[:message].first.class)
        .to eq(DeregistrationMessageValidator)
    end
  end

  describe "#submit" do
    context "when the form is valid" do
      it "should submit" do
        expect(form.submit(state_transition: "revoke", message: "This exemption is no longer relevant")).to eq(true)
      end
    end

    context "when the form is not valid" do
      it "should not submit" do
        expect(form.submit(state_transition: "deactivate", message: "X" * 501)).to eq(false)
      end
    end
  end
end
