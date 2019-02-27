# frozen_string_literal: true

FactoryBot.define do
  factory :transient_person, class: WasteExemptionsEngine::TransientPerson do
    sequence :first_name do |n|
      "Firstperson#{n}"
    end

    sequence :last_name do |n|
      "Lastperson#{n}"
    end
  end
end
