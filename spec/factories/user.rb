# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    role { "system" }
    password { "Secret123" }

    trait :system do
      role { "system" }
    end

    trait :super_agent do
      role { "super_agent" }
    end

    trait :admin_agent do
      role { "admin_agent" }
    end

    trait :data_agent do
      role { "data_agent" }
    end

    trait :inactive do
      active { false }
    end
  end
end
