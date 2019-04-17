# frozen_string_literal: true

class EditCompletionService
  def initialize(edited_registration)
    @edited_registration = edited_registration
    @registration = find_original_registration
  end

  def complete
    copy_data_from_edited_registration
    @registration.save!
    @edited_registration.destroy
  end

  private

  def find_original_registration
    WasteExemptionsEngine::Registration.where(reference: @edited_registration.reference).first
  end

  def copy_data_from_edited_registration
    copy_addresses
    copy_exemptions
    copy_people

    @registration.update_attributes(@edited_registration.registration_attributes)
  end

  def copy_addresses
    @registration.addresses = []
    @edited_registration.transient_addresses.each do |transient_address|
      new_address = WasteExemptionsEngine::Address.new(transient_address.address_attributes)
      @registration.addresses << new_address
    end
  end

  def copy_exemptions
    @registration.exemptions = []
    @edited_registration.exemptions.each do |exemption|
      @registration.exemptions << exemption
    end
  end

  def copy_people
    @registration.people = []
    @edited_registration.transient_people.each do |transient_person|
      new_person = WasteExemptionsEngine::Person.new(transient_person.person_attributes)
      @registration.people << new_person
    end
  end
end
