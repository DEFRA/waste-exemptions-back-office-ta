# frozen_string_literal: true

class ExemptionBulkReport
  def initialize(registration_exemption)
    @registration_exemption = registration_exemption
  end

  private

  attr_reader :registration_exemption
end
