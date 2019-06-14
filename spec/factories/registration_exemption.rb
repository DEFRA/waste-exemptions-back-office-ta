# frozen_string_literal: true

FactoryBot.define do
  factory :registration_exemption, class: WasteExemptionsEngine::RegistrationExemption do
    exemption
    expires_on { Date.today + 3.years }
    registered_on { Date.today }

    trait :active do
      state { "active" }
    end

    trait :ceased do
      state { "ceased" }
      deregistration_message { "Ceased for reasons" }
      deregistered_at { Date.today - 1.day }
    end

    trait :revoked do
      state { "revoked" }
      deregistration_message { "Revoked for reasons" }
      deregistered_at { Date.today - 1.day }
    end

    trait :with_registration do
      registration
    end
  end
end
