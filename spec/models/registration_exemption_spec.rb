# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::RegistrationExemption, type: :model do
  subject(:registration_exemption) { build(:registration).registration_exemptions.first }
  let(:permitted_states) { registration_exemption.aasm.states(permitted: true).map(&:name) }

  deregistration_states = %i[cease revoke]
  transitions = deregistration_states + [:expire]
  inactive_states = %i[ceased revoked expired]

  describe "#order_by_state_then_id" do
    let(:registration) do
      registration = create(:registration)
      5.times do
        %i[active ceased revoked expired].each do |state|
          create(
            :registration_exemption,
            registration: registration,
            exemption: WasteExemptionsEngine::Exemption.all.sample,
            state: state
          )
        end
      end
      registration
    end

    it "returns the registration exemptions in a specific order of states and then by exemption id" do
      sorted_registration_exemptions = registration.registration_exemptions.order_by_state_then_exemption_id
      # --- Confirm the States are in the expected order ---
      # We need to use chunk_while instead of uniq to confirm the states are sorted as uniq could
      # pass the test but fail the expectation.
      grouped_states = sorted_registration_exemptions.map(&:state).chunk_while { |a, b| a == b }.to_a
      expect(grouped_states.count).to eq(4) # This can only be the case if the states are ordered.
      expect(grouped_states.flatten.uniq).to eq(%w[active ceased revoked expired]) # The correct order

      # --- Confirm the IDs are sequential for each state ---
      sorted_states_and_ids = sorted_registration_exemptions.map { |re| [re.state, re.exemption_id] }
      # Group the IDs for each state so we confirm the ids for each group are sequential
      grouped_ids = sorted_states_and_ids.group_by(&:first).map { |_state, state_id_pairs| state_id_pairs.map(&:last) }
      expect(grouped_ids.count).to eq(4) # Confirm there are the same number of groups as states
      grouped_ids.each do |ids|
        expect(ids.sort).to eq(ids)
      end
    end
  end

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
