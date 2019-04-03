# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Registration, type: :model do
  let(:matching_registration) { create(:registration) }
  let(:non_matching_registration) { create(:registration) }

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
      context "and at least one exemption registration is active" do
        let(:registration) do
          registration = create(:registration)
          registration_exemptions = registration.registration_exemptions.to_a
          reg_exemption = registration_exemptions.shift
          registration_exemptions.each(&:revoke!)
          reg_exemption.state = "active"
          reg_exemption.save!
          registration
        end

        it "returns \"active\"" do
          expect(registration.state).to eq "active"
        end
      end

      context "and none of the exemption registrations are active" do
        let(:registration) do
          registration = create(:registration)
          registration_exemptions = registration.registration_exemptions.to_a
          reg_exemption = registration_exemptions.shift
          registration_exemptions.each do |re|
            re.revoke!
            re.deregistered_on = 1.day.ago
            re.save!
          end
          reg_exemption.cease!
          registration
        end

        it "returns the state of the exemption registration that has changed state most recently" do
          expect(registration.state).to eq "ceased"
        end
      end
    end
  end
end
