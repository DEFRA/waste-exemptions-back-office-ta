# frozen_string_literal: true

FactoryBot.define do
  factory :ad_renewal_letters_export, class: WasteExemptionsEngine::AdRenewalLettersExport do
    expires_on { 35.days.from_now }

    trait :printed do
      printed_by { "super_agent@wex.gov.uk" }
      printed_on { Date.today }
    end
  end
end
