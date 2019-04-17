# frozen_string_literal: true

FactoryBot.define do
  factory :registration_exemption, class: WasteExemptionsEngine::RegistrationExemption do

    expires_on { Date.today + 3.years }

    trait :active do
      state { "active" }
    end

    trait :ceased do
      state { "ceased" }
      deregistration_message { "Ceased for reasons" }
      deregistered_on { Date.today }
    end

    trait :revoked do
      state { "revoked" }
      deregistration_message { "Revoked for reasons" }
      deregistered_on { Date.today }
    end
  end
end
