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
                      to: :ceased,
                      after: :deregister_exemption
        end

        event :revoke do
          transitions from: :active,
                      to: :revoked,
                      after: :deregister_exemption
        end

        event :expire do
          transitions from: :active,
                      to: :expired
        end
      end

      # Transition effects
      def deregister_exemption
        self.deregistered_on = Date.today
        save!
      end
    end
  end
end
