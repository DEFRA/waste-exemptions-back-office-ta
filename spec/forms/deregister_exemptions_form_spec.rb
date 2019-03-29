# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregisterExemptionsForm, type: :model do
  subject(:form) { described_class.new }
  let(:super_agent_user) { build(:user, :super_agent) }
  let(:active_registration_exemption) do
    reg_exemption = build(:registration).registration_exemptions.first
    reg_exemption.state = "active"
    reg_exemption
  end
  let(:deregistration_service) { DeregistrationService.new(super_agent_user, active_registration_exemption) }

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
        good_params = { state_transition: "revoke", message: "This exemption is no longer relevant" }
        expect(form.submit(good_params, deregistration_service)).to eq(true)
      end
    end

    context "when the form is not valid" do
      it "should not submit" do
        bad_params = { state_transition: "deactivate", message: Helpers::TextGenerator.random_string(501) }
        expect(form.submit(bad_params, deregistration_service)).to eq(false)
      end
    end
  end
end
