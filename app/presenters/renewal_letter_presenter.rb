# frozen_string_literal: true

class RenewalLetterPresenter < BaseLetterPresenter
  def exemption_description(exemption)
    "#{exemption.code} #{exemption.summary}"
  end

  def expiry_date
    # Currently you can only add exemptions when you register, so we can assume they expire at the same time
    registration_exemptions.first.expires_on.to_formatted_s(:day_month_year)
  end

  def listable_exemptions
    @_listable_exemptions = exemptions.first(20)
  end

  def unlisted_exemption_count
    @_unlisted_exemption_count = calculate_number_of_unlisted_exemptions
  end

  private

  def calculate_number_of_unlisted_exemptions
    total_exemption_count = exemptions.count
    listable_exemptions_count = listable_exemptions.count

    if listable_exemptions_count < total_exemption_count
      total_exemption_count - listable_exemptions_count
    else
      0
    end
  end
end
