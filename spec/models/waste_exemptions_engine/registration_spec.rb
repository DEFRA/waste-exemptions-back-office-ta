# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Registration, type: :model do
  let(:matching_registration) { create(:registration) }
  let(:non_matching_registration) { create(:registration) }

  describe "#past_renewal_window?" do
    let(:registration_exemption) { build(:registration_exemption, expires_on: expires_on) }

    subject(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

    before do
      WasteExemptionsBackOffice::Application.config.renewal_window_open_before_days = "28"
      WasteExemptionsBackOffice::Application.config.registration_renewal_grace_window = "30"
    end

    context "when the renewal period hasn't finished yet" do
      let(:expires_on) { 50.days.from_now }

      it "returns false" do
        expect(registration).to_not be_past_renewal_window
      end
    end

    context "when the renewal period has passed" do
      let(:expires_on) { 50.days.ago }

      it "returns true" do
        expect(registration).to be_past_renewal_window
      end
    end
  end

  describe "#in_renewal_window?" do
    let(:registration_exemption) { build(:registration_exemption, expires_on: expires_on) }

    subject(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

    before do
      WasteExemptionsBackOffice::Application.config.renewal_window_open_before_days = "28"
      WasteExemptionsBackOffice::Application.config.registration_renewal_grace_window = "30"
    end

    context "when the renewal period hasn't started yet" do
      let(:expires_on) { 50.days.from_now }

      it "returns false" do
        expect(registration).to_not be_in_renewal_window
      end
    end

    context "when the renewal period has started" do
      let(:expires_on) { 10.days.from_now }

      it "returns true" do
        expect(registration).to be_in_renewal_window
      end
    end

    context "when the expire date is in the past but still in the grace period" do
      let(:expires_on) { 10.days.ago }

      it "returns true" do
        expect(registration).to be_in_renewal_window
      end
    end

    context "when the grace period has passed" do
      let(:expires_on) { 50.days.ago }

      it "returns false" do
        expect(registration).to_not be_in_renewal_window
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
