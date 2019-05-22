# frozen_string_literal: true

FactoryBot.define do
  factory :exemption, class: WasteExemptionsEngine::Exemption do
    category { 0 }
    url { "https://example.gov.uk/guidance/waste-exemptions-using-waste" }
    summary { "Use of spam in cooking" }
    description { "Use of spam in cooking using suitable spam rather than virgin spam or spam which has ceased to be spam - for example by cooking spam with chips." }
    guidance { "This exemption allows you to use suitable spam rather than virgin spam or spam which has ceased to be spam - for example by cooking spam with chips." }

    sequence :code do |n|
      "F#{n}"
    end
  end
end
