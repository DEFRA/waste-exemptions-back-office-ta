# frozen_string_literal: true

module WasteExemptionsEngine
  module CanDeactivateExemption
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :state do
        state :active
        state :ceased
        state :expired
        state :revoked

        event :cease do
          transitions from: :active,
                      to: :ceased
        end

        event :revoke do
          transitions from: :active,
                      to: :revoked
        end

        event :expire do
          transitions from: :active,
                      to: :expired
        end
      end
    end
  end
end
