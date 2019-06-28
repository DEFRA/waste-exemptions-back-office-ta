# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: WasteExemptionsEngine::Registration do
    location { "england" }
    applicant_phone { "01234567890" }
    contact_phone { "01234567890" }
    business_type { "limitedCompany" }
    company_no { "09360070" }
    on_a_farm { true }
    is_a_farmer { true }

    submitted_at { DateTime.now }

    exemptions { WasteExemptionsEngine::Exemption.first(3) }

    sequence :applicant_email do |n|
      "applicant#{n}@example.com"
    end

    sequence :applicant_first_name do |n|
      "Firstapp#{n}"
    end

    sequence :applicant_last_name do |n|
      "Lastapp#{n}"
    end

    sequence :contact_email do |n|
      "contact#{n}@example.com"
    end

    sequence :contact_first_name do |n|
      "Firstcontact#{n}"
    end

    sequence :contact_last_name do |n|
      "Lastcontact#{n}"
    end

    sequence :operator_name do |n|
      "Operator #{n}"
    end

    sequence :reference do |n|
      "WEX#{n}"
    end

    addresses do
      [build(:address, :operator),
       build(:address, :contact),
       build(:address, :site)]
    end

    trait :limited_company do
      business_type { "limitedCompany" }
    end

    trait :limited_liability_partnership do
      business_type { "limitedLiabilityPartnership" }
    end

    trait :local_authority do
      business_type { "localAuthority" }
    end

    trait :charity do
      business_type { "charity" }
    end

    trait :partnership do
      business_type { "partnership" }
      people { build_list(:person, 2) }
    end

    trait :sole_trader do
      business_type { "soleTrader" }
    end

    trait :site_uses_address do
      addresses do
        [build(:address, :operator),
         build(:address, :contact),
         build(:address, :site_uses_address)]
      end
    end

    trait :with_active_exemptions do
      after(:build) do |reg|
        reg.registration_exemptions.each do |re|
          re.state = :active
          re.expires_on = Date.today + 3.years
          re.registered_on = Date.today
        end
      end
    end
  end
end
