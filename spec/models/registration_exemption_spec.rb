# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::RegistrationExemption, type: :model do
  subject(:registration_exemption) { build(:registration).registration_exemptions.first }
  let(:permitted_states) { registration_exemption.aasm.states(permitted: true).map(&:name) }

  deregistration_states = %i[cease revoke]
  transitions = deregistration_states + [:expire]
  inactive_states = %i[ceased revoked expired]

  describe "exemption state" do
    context "when the state is 'active'" do
      before(:each) do
        registration_exemption.state = :active
        registration_exemption.deregistered_on = nil
      end

      it "can transition to any of the inactive states" do
        expect(permitted_states).to match_array(inactive_states)
      end

      transitions.zip(inactive_states).each do |transition, expected_state|
        context "and the '#{transition}' transition is executed" do
          it "reflects the correct state" do
            expect { registration_exemption.send("#{transition}!") }
              .to change { registration_exemption.state }
              .from("active")
              .to(expected_state.to_s)
          end

          if deregistration_states.include? transition
            it "updates the deregistered_on time stamp" do
              expect { registration_exemption.send("#{transition}!") }
                .to change { registration_exemption.deregistered_on }
                .from(nil)
                .to(Date.today)
            end
          else
            it "does not update the deregistered_on time stamp" do
              expect { registration_exemption.send("#{transition}!") }
                .to_not change { registration_exemption.deregistered_on }
                .from(nil)
            end
          end
        end
      end
    end

    inactive_states.each do |inactive_state|
      context "when the state is #{inactive_state}" do
        before(:each) { registration_exemption.state = inactive_state }
        it "can not transition to any other status" do
          expect(permitted_states).to be_empty
        end
      end
    end
  end
end
