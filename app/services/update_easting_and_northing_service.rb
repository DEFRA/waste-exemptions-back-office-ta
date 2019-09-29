# frozen_string_literal: true

class UpdateEastingAndNorthingService < ::WasteExemptionsEngine::BaseService
  attr_reader :address

  def run(address)
    @address = address

    address.update_attributes!(x: x, y: y)
  rescue StandardError => e
    Airbrake.notify e, address_id: address.id
    Rails.logger.error "Failed easting and northing lookup for address: #{address.id}. Error:\n#{e}"
  end

  private

  def x
    @_x ||= easting_and_northing[:x]
  end

  def y
    @_y ||= easting_and_northing[:y]
  end

  def easting_and_northing
    @_easting_and_northing ||= address.located_by_grid_reference? ? map_fetch : os_fetch
  end

  def map_fetch
    begin
      location = OsMapRef::Location.for(address.grid_reference)
      x = location.easting
      y = location.northing
    rescue OsMapRef::Error
      x = y = 0.00
    end

    { x: x, y: y }
  end

  def os_fetch
    results = WasteExemptionsEngine::AddressFinderService.new(address.postcode).search_by_postcode

    if results.is_a?(Symbol)
      x, y = nil
    elsif results.empty?
      x = y = 0.00
    else
      x = results.first["x"].to_f
      y = results.first["y"].to_f
    end

    { x: x, y: y }
  end
end
