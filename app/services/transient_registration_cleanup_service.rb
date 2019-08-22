# frozen_string_literal: true

class TransientRegistrationCleanupService < ::WasteExemptionsEngine::BaseService
  def run
    transient_registrations_to_remove.each(&:destroy)
  end

  private

  def transient_registrations_to_remove
    WasteExemptionsEngine::TransientRegistration.where("created_at < ?", oldest_possible_date)
  end

  def oldest_possible_date
    30.days.ago
  end
end
