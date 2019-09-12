# frozen_string_literal: true

FactoryBot.define do
  factory :ad_renewal_letters_export, class: WasteExemptionsEngine::AdRenewalLettersExport do
    expires_on { 35.days.from_now }
  end
end
