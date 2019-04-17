# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::EditedRegistration, type: :model do
  subject(:edited_registration) { create(:edited_registration) }

  it "subclasses TransientRegistration" do
    expect(described_class).to be < WasteExemptionsEngine::TransientRegistration
  end

  describe "public interface" do
    Helpers::ModelProperties::TRANSIENT_REGISTRATION.each do |property|
      it "responds to property" do
        expect(edited_registration).to respond_to(property)
      end
    end
  end

  describe "#initialize" do
    context "when it is initialized with a registration" do
      let(:registration) { create(:registration) }
      let(:edited_registration) { described_class.new(reference: registration.reference) }

      Helpers::ModelProperties::EDITED_REGISTRATION_UNCOPYABLE.each do |property|
        it "copies #{property} from the registration" do
          expect(edited_registration[property]).to eq(registration[property])
        end
      end

      it "copies the addresses from the registration" do
        %i[operator_address contact_address site_address].each do |address|
          copyable_attributes = registration.send(address).attributes.except("id",
                                                                             "registration_id",
                                                                             "created_at",
                                                                             "updated_at")
          expect(edited_registration.send(address).attributes).to include(copyable_attributes)
        end
      end

      it "copies the people from the registration" do
        registration.people.each_with_index do |person, index|
          copyable_attributes = person.attributes.except("id",
                                                         "registration_id",
                                                         "created_at",
                                                         "updated_at")
          expect(edited_registration.people[index].attributes).to include(copyable_attributes)
        end
      end

      it "copies the exemptions from the registration" do
        registration.exemptions.each do |exemption|
          expect(edited_registration.exemptions).to include(exemption)
        end
      end
    end
  end
end
