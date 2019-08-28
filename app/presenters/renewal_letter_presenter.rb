# frozen_string_literal: true

class RenewalLetterPresenter < BaseLetterPresenter
  def expiry_date
    # Currently you can only add exemptions when you register, so we can assume they expire at the same time
    registration_exemptions.first.expires_on.to_formatted_s(:day_month_year)
  end
end
