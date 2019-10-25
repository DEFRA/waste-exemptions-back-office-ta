# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Registration, type: :model do
  let(:matching_registration) { create(:registration) }
  let(:non_matching_registration) { create(:registration) }
  subject(:registration) { build(:registration) }

  describe ".renewals" do
    it "returns registrations that are renewals of older registrations" do
      registration = create(:registration)
      renewal = create(:registration, referring_registration: registration)

      result = described_class.renewals

      expect(result).to include(renewal)
      expect(result).to_not include(registration)
    end
  end

  describe ".site_address_is_not_nccc" do
    let(:registration) { create(:registration, :site_uses_address) }

    it "returns registrations that don't have the NCCC postcode in the site address" do
      registration.site_address.update_attributes(postcode: "AA1 1AA")

      result = described_class.site_address_is_not_nccc

      expect(result).to include(registration)
    end

    it "does not return registrations that do have the NCCC postcode in the site address" do
      registration.site_address.update_attributes(postcode: "S9 4WF")

      result = described_class.site_address_is_not_nccc

      expect(result).to_not include(registration)
    end
  end

  describe "#renewable?" do

    context "when the registration is in a renewal window and renewal state" do
      it "returns true" do
        allow(registration).to receive(:in_renewal_window?).and_return(true)
        allow(registration).to receive(:in_renewable_state?).and_return(true)

        expect(registration).to be_renewable
      end
    end

    context "when the registration is not in a renewal window" do
      it "returns false" do
        allow(registration).to receive(:in_renewal_window?).and_return(false)
        allow(registration).to receive(:in_renewable_state?).and_return(true)

        expect(registration).to_not be_renewable
      end
    end

    context "when the registration is not in a renewal state" do
      it "returns false" do
        allow(registration).to receive(:in_renewal_window?).and_return(true)
        allow(registration).to receive(:in_renewable_state?).and_return(false)

        expect(registration).to_not be_renewable
      end
    end
  end

  describe "#in_renewable_state?" do
    before do
      allow(registration).to receive(:state).and_return(state)
    end

    context "when the state is active" do
      let(:state) { "active" }

      it "returns true" do
        expect(registration).to be_in_renewable_state
      end
    end

    context "when the state is expired" do
      let(:state) { "expired" }

      it "returns true" do
        expect(registration).to be_in_renewable_state
      end
    end

    context "when the state is not expired nor active" do
      let(:state) { "ceased" }

      it "returns false" do
        expect(registration).to_not be_in_renewable_state
      end
    end
  end

  describe "#search_registration_and_relations" do
    let(:term) { nil }
    let(:scope) { WasteExemptionsEngine::Registration.search_registration_and_relations(term) }

    context "when the search term is an applicant_email" do
      let(:term) { matching_registration.applicant_email }

      it "returns registrations with a matching reference" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end

      context "when the search term is in the wrong case" do
        let(:term) { matching_registration.applicant_email.upcase }

        it "still returns matching results" do
          expect(scope).to include(matching_registration)
        end
      end
    end

    context "when the search term is an applicant_first_name" do
      let(:term) { matching_registration.applicant_first_name }

      it "returns registrations with a matching applicant name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an applicant_last_name" do
      let(:term) { matching_registration.applicant_last_name }

      it "returns registrations with a matching applicant name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an applicant's full name" do
      let(:term) { "#{matching_registration.applicant_first_name} #{matching_registration.applicant_last_name}" }

      it "returns registrations with a matching applicant name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact_email" do
      let(:term) { matching_registration.contact_email }

      it "returns registrations with a matching reference" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact_first_name" do
      let(:term) { matching_registration.contact_first_name }

      it "returns registrations with a matching contact name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact_last_name" do
      let(:term) { matching_registration.contact_last_name }

      it "returns registrations with a matching contact name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact's full name" do
      let(:term) { "#{matching_registration.contact_first_name} #{matching_registration.contact_last_name}" }

      it "returns registrations with a matching contact name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an operator_name" do
      let(:term) { matching_registration.operator_name }

      it "returns registrations with a matching operator name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end

      context "when the search term is a partial operator_name" do
        let(:term) { matching_registration.operator_name[0, 5] }

        it "returns registrations with a matching operator name" do
          expect(scope).to include(matching_registration)
        end
      end
    end

    context "when the search term is a reference" do
      let(:term) { matching_registration.reference }

      it "returns registrations with a matching reference" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is a related address's postcode" do
      let(:address) { matching_registration.addresses.last }
      let(:term) { address.postcode }

      context "when the address is a site address" do
        it "is included in the scope" do
          expect(scope).to include(matching_registration)
        end
      end

      context "when the address is not a site address" do
        let(:address) { matching_registration.addresses.first }

        it "is not included in the scope" do
          expect(scope).to_not include(matching_registration)
        end
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is a related person's name" do
      let(:matching_registration) { create(:registration, :partnership) }
      let(:non_matching_registration) { create(:registration, :partnership) }
      let(:term) do
        person = matching_registration.people.first
        "#{person.first_name} #{person.last_name}"
      end

      it "returns registrations with a matching person" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end
  end

  describe "#active?" do
    context "when the state is :active" do
      before(:each) { allow(subject).to receive(:state).and_return("active") }

      it "returns `true`" do
        expect(subject.active?).to eq true
      end
    end
    %w[ceased revoked expired].each do |state|
      context "when the state is :#{state}" do
        before(:each) { allow(subject).to receive(:state).and_return(state) }

        it "returns `false`" do
          expect(subject.active?).to eq false
        end
      end
    end
  end

  describe "#state" do
    %w[active ceased revoked expired].each do |state|
      context "when all of the registration's exemption registrations are #{state}" do
        let(:registration) do
          registration = create(:registration)
          registration.registration_exemptions.each do |re|
            re.state = state
            re.save!
          end
          registration
        end

        it "returns \"#{state}\"" do
          expect(registration.state).to eq state
        end
      end
    end

    context "when the registration's exemption registrations have mixed states" do
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
