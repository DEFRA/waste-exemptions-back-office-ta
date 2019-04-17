# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditCompletionService do
  let(:edited_registration) { create(:edited_registration) }
  let(:registration) do
    WasteExemptionsEngine::Registration.where(reference: edited_registration.reference).first
  end
  let(:service) { EditCompletionService.new(edited_registration) }

  describe "complete" do
    (Helpers::ModelProperties::REGISTRATION - %i[is_a_farmer on_a_farm reference submitted_at]).each do |attribute|
      it "updates the registration data for #{attribute}" do
        old_value = registration[attribute]
        new_value = "#{old_value}foo"
        edited_registration[attribute] = new_value

        expect { service.complete }.to change {
          registration.reload[attribute]
        }.from(old_value).to(new_value)
      end
    end

    %i[is_a_farmer on_a_farm].each do |attribute|
      it "updates the registration data for #{attribute}" do
        old_value = registration[attribute]
        new_value = !old_value
        edited_registration[attribute] = new_value

        expect { service.complete }.to change {
          registration.reload[attribute]
        }.from(old_value).to(new_value)
      end
    end

    it "updates the registration addresses" do
      old_value = registration.site_address.grid_reference
      new_value = "#{old_value}foo"
      edited_registration.site_address.grid_reference = new_value

      expect { service.complete }.to change {
        registration.reload.site_address.grid_reference
      }.from(old_value).to(new_value)
    end

    %i[operator_address contact_address site_address].each do |address_type|
      before do
        # Make sure the edited values are different to the original ones
        edited_registration.send(address_type).attributes.each do |key, value|
          # Append 'foo' to the end of all string attributes
          edited_registration.send(address_type).update_attribute(key, "#{value}foo") if value.is_a?(String)
        end
      end

      it "copies the #{address_type} from the registration" do
        old_attributes = registration.send(address_type).attributes.except("registration_id",
                                                                           "created_at",
                                                                           "updated_at",
                                                                           "id")
        new_attributes = edited_registration.send(address_type).attributes.except("transient_registration_id",
                                                                                  "created_at",
                                                                                  "updated_at",
                                                                                  "id")

        expect { service.complete }.to change {
          registration.reload.send(address_type).attributes.except("registration_id",
                                                                   "created_at",
                                                                   "updated_at",
                                                                   "id")
        }.from(old_attributes).to(new_attributes)
      end
    end

    it "copies the people from the registration" do
      # Make sure the edited people are different to the original ones
      edited_registration.people.each do |person|
        person.attributes.each do |key, value|
          # Append 'foo' to the end of all string attributes
          person.update_attribute(key, "#{value}foo") if value.is_a?(String)
        end
      end

      # Get all attributes from all the original people (with a few exceptions)
      old_people = registration.people.map do |p|
        p.attributes.except("registration_id", "created_at", "updated_at", "id")
      end

      # Get all attributes from all the edited people (with a few exceptions)
      new_people = edited_registration.people.map do |p|
        p.attributes.except("transient_registration_id", "created_at", "updated_at", "id")
      end

      expect { service.complete }.to change {
        # Get all attributes from all the registration's people
        registration.reload.people.map do |p|
          p.attributes.except("registration_id", "created_at", "updated_at", "id")
        end
      }.from(old_people).to(new_people)
    end

    it "copies the exemptions from the registration" do
      # Make sure the edited exemptions are different to the original ones
      edited_registration.exemptions = WasteExemptionsEngine::Exemption.last(3)

      service.complete
      expect(edited_registration.exemptions).to match_array(registration.exemptions)
    end

    context "when an attribute is no longer used after editing" do
      before do
        edited_registration.contact_position = nil
      end

      it "removes the attribute from the registration" do
        old_value = registration.contact_position

        expect { service.complete }.to change {
          registration.reload.contact_position
        }.from(old_value).to(nil)
      end
    end

    it "deletes the edited_registration" do
      expect(WasteExemptionsEngine::EditedRegistration.where(reference: edited_registration.reference).count).to eq(1)
      expect { service.complete }.to change {
        WasteExemptionsEngine::EditedRegistration.count
      }.by(-1)
      expect(WasteExemptionsEngine::EditedRegistration.where(reference: edited_registration.reference).count).to eq(0)
    end
  end
end
