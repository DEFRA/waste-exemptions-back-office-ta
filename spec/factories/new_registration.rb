# frozen_string_literal: true

FactoryBot.define do
  factory :new_registration, class: WasteExemptionsEngine::NewRegistration do
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

    transient_addresses do
      [build(:transient_address, :operator),
       build(:transient_address, :contact),
       build(:transient_address, :site)]
    end

    exemptions { build_list(:exemption, 5) }

    transient_people { [build(:transient_person), build(:transient_person)] }
  end
end
