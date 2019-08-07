# frozen_string_literal: true

FactoryBot.define do
  factory :renewing_registration, class: WasteExemptionsEngine::RenewingRegistration do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      registration = create(:registration)

      new(reference: registration.reference, token: registration.renew_token)
    end
  end
end
