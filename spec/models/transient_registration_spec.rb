# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::TransientRegistration, type: :model do
  let(:matching_registration) { create(:transient_registration) }
  let(:non_matching_registration) { create(:transient_registration) }

  describe "#search_registration_and_relations" do
    let(:term) { nil }
    let(:scope) { WasteExemptionsEngine::TransientRegistration.search_registration_and_relations(term) }

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
      let(:address) { matching_registration.transient_addresses.last }
      let(:term) { address.postcode }

      context "when the address is a site address" do
        it "is included in the scope" do
          expect(scope).to include(matching_registration)
        end
      end

      context "when the address is not a site address" do
        let(:address) { matching_registration.transient_addresses.first }

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
        person = matching_registration.transient_people.first
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
end
