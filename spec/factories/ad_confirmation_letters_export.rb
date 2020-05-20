# frozen_string_literal: true

FactoryBot.define do
  factory :ad_confirmation_letters_export, class: WasteExemptionsEngine::AdConfirmationLettersExport do
    created_on { Date.today }
    number_of_letters { 0 }

    trait :printed do
      printed_by { "super_agent@wex.gov.uk" }
      printed_on { Date.today }
    end
  end
end
