# frozen_string_literal: true

FactoryBot.define do
  factory :ad_renewal_letters_export, class: WasteExemptionsEngine::AdRenewalLettersExport do
    expires_on { 35.days.from_now }
    number_of_letters { 0 }

    trait :printed do
      printed_by { "super_agent@wex.gov.uk" }
      printed_on { Date.today }
    end
  end
end
