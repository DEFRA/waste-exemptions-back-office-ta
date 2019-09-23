# frozen_string_literal: true

class EaAreaLookupService < ::WasteExemptionsEngine::BaseService
  attr_reader :address

  def run(address)
    @address = address

    address.update_attributes!(area: area)
  rescue StandardError => e
    Airbrake.notify e, address_id: address.id
    Rails.logger.error "Failed area lookup for address: #{address.id}. Error:\n#{e}"
  end

  private

  def area
    @_area ||= WasteExemptionsEngine::AreaLookupService.run(easting: address.x, northing: address.y)
  end
end
