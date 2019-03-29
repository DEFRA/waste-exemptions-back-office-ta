# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregistrationService do
  let(:active_registration_exemption) do
    reg_exemption = build(:registration).registration_exemptions.first
    reg_exemption.state = "active"
    reg_exemption
  end
  let(:inactive_registration_exemption) do
    reg_exemption = build(:registration).registration_exemptions.first
    reg_exemption.state = "revoked"
    reg_exemption
  end
  let(:super_agent_user) { build(:user, :super_agent) }
  let(:data_agent_user) { build(:user, :data_agent) }

  describe "#deregister!" do
    context "when the registration_exemption is active" do
      context "and the user has sufficient permissions" do
        subject(:dereg_service) { described_class.new(super_agent_user, active_registration_exemption) }

        %i[revoke cease].each do |allowed_state|
          context "and the new state is '#{allowed_state}'" do
            it "changes the registration_exemption state" do
              expect { dereg_service.deregister!(allowed_state) }
                .to change { active_registration_exemption.state }
                .from("active")
                .to("#{allowed_state}d") # simple past tense
            end
          end
        end

        context "and the new state is 'pending'" do
          it "raises an error" do
            expect { dereg_service.deregister!(:pending) }.to raise_error(NoMethodError)
          end
        end
      end

      context "and the user has insufficient permissions" do
        subject(:dereg_service) { described_class.new(data_agent_user, active_registration_exemption) }

        it "does not change the registration_exemption state" do
          expect { dereg_service.deregister!(:revoke) }
            .to_not change { active_registration_exemption.state }
            .from("active")
        end
      end
    end

    context "when the registration_exemption is inactive" do
      context "and the user has sufficient permissions" do
        subject(:dereg_service) { described_class.new(super_agent_user, inactive_registration_exemption) }

        it "does not change the registration_exemption state" do
          expect { dereg_service.deregister!(:revoke) }
            .to_not change { inactive_registration_exemption.state }
            .from("revoked")
        end
      end

      context "and the user has insufficient permissions" do
        subject(:dereg_service) { described_class.new(data_agent_user, inactive_registration_exemption) }

        it "does not change the registration_exemption state" do
          expect { dereg_service.deregister!(:revoke) }
            .to_not change { inactive_registration_exemption.state }
            .from("revoked")
        end
      end
    end
  end
end
