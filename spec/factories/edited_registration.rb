# frozen_string_literal: true

FactoryBot.define do
  factory :edited_registration, class: WasteExemptionsEngine::EditedRegistration do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      new(reference: create(:registration).reference)
    end
  end
end
