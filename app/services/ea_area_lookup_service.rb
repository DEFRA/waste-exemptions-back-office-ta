# frozen_string_literal: true

class EaAreaLookupService < ::WasteExemptionsEngine::BaseService
  attr_reader :easting, :northing

  def run(address)
    @easting = address.x
    @northing = address.y

    if response.successful?
      address.update_attributes!(area: response.areas.first.long_name)
    end
  # rescue StandardError => e
  #   Airbrake.notify e, address_id: address.id
  #   Rails.logger.error "Failed area lookup for address: #{address.id}. Error:\n#{e}"
  end

  private

  def response
    @_response ||= DefraRuby::Area::PublicFaceAreaService.run(easting, northing)
  end
end
