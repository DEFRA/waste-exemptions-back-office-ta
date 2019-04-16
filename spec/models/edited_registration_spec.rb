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
    end
  end
end
