# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration_exemption")

module WasteExemptionsEngine
  class RegistrationExemption < ActiveRecord::Base
    self.table_name = "registration_exemptions"

    include CanDeactivateExemption
    include CanBeOrderedByStateAndExemptionId

    scope :data_for_month, lambda { |first_day_of_the_month|
      registered_on_range = (first_day_of_the_month..first_day_of_the_month.end_of_month)

      where(registered_on: registered_on_range)
        .includes(:exemption)
        .includes(registration: :addresses)
        .order(:registered_on, :registration_id)
    }

    scope :not_expired, -> { where("expires_on >= CURRENT_DATE") }
    scope :expired, -> { where("expires_on < CURRENT_DATE") }

    scope :all_active_exemptions, lambda {
      active
        .not_expired
        .includes(:exemption)
        .includes(registration: :addresses)
        .order(:registered_on, :registration_id)
    }
  end
end
