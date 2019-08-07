# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration")

module WasteExemptionsEngine
  class Registration < ActiveRecord::Base
    include CanBeSearchedLikeRegistration

    scope :search_for_site_address_postcode, lambda { |term|
      joins(:addresses).merge(Address.search_for_postcode(term).site)
    }

    scope :search_for_person_name, lambda { |term|
      joins(:people).merge(Person.search_for_name(term))
    }

    def active?
      state == "active"
    end

    def state
      raise "A Registration must have at least one RegistrationExemption." if registration_exemptions.empty?

      return "active" if registration_exemptions.select(&:active?).any?
      return "revoked" if registration_exemptions.select(&:revoked?).any?
      return "expired" if registration_exemptions.select(&:expired?).any?

      "ceased"
    end

    def in_renewal_window?
      (expires_on - renewal_window_open_before_days.days) < Time.now &&
        !past_renewal_window?
    end

    def past_renewal_window?
      (expires_on + registration_renewal_grace_window.days) < Time.now
    end

    private

    def renewal_window_open_before_days
      WasteExemptionsBackOffice::Application.config.renewal_window_open_before_days.to_i
    end

    def registration_renewal_grace_window
      WasteExemptionsBackOffice::Application.config.registration_renewal_grace_window.to_i
    end

    def expires_on
      @_expires_on ||= registration_exemptions.pluck(:expires_on).presence&.sort.first
    end
  end
end
