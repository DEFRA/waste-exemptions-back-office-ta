# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Registration do
    describe "#state" do
      subject(:registration) { create(:registration, registration_exemptions: registration_exemptions) }

      context "When at least one exemption is in an active status" do
        let(:registration_exemptions) do
          [
            build(:registration_exemption, :active),
            build(:registration_exemption, :revoked)
          ]
        end

        it "returns active status" do
          expect(registration.state).to eq("active")
        end
      end

      context "When no exemption in the registration is still active" do
        let(:registration_exemptions) do
          [
            build(:registration_exemption, :revoked),
            build(:registration_exemption, :ceased)
          ]
        end

        context "and at least one exemption is in a revoked status" do
          it "returns revoked status" do
            expect(registration.state).to eq("revoked")
          end
        end

        context "no exemption is in a revoked status" do
          let(:registration_exemptions) do
            [
              build(:registration_exemption, :expired),
              build(:registration_exemption, :ceased)
            ]
          end

          context "and at least one exemption is in a expired status" do
            it "returns expired status" do
              expect(registration.state).to eq("expired")
            end
          end

          context "no exemption is in a expired status" do
            let(:registration_exemptions) do
              [
                build(:registration_exemption, :ceased),
                build(:registration_exemption, :ceased)
              ]
            end

            it "returns ceased status" do
              expect(registration.state).to eq("ceased")
            end
          end
        end
      end
    end
  end
end
