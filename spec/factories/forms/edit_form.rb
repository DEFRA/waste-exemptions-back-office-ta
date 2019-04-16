# frozen_string_literal: true

FactoryBot.define do
  factory :edit_form, class: WasteExemptionsEngine::EditForm do
    initialize_with do
      new(create(:edited_registration, workflow_state: "edit_form"))
    end
  end
end
