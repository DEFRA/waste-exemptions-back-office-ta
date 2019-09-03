# frozen_string_literal: true

class RenewalLetterPresenter < BaseLetterPresenter
  # Provides the full postal address for the letter.
  def postal_address_lines
    lines = [contact_full_name]
    lines << operator_name unless business_type == WasteExemptionsEngine::Registration::BUSINESS_TYPES[:sole_trader]
    lines << address_lines(contact_address)
    lines.flatten!.reject(&:blank?)
  end

  def exemption_description(exemption)
    "#{exemption.code} #{exemption.summary}"
  end

  def expiry_date
    # Currently you can only add exemptions when you register, so we can assume they expire at the same time
    registration_exemptions.first.expires_on.to_formatted_s(:day_month_year)
  end

  def listable_exemptions
    @_listable_exemptions ||= exemptions.first(18)
    @_listable_exemptions
  end

  def unlisted_exemption_count
    @_unlisted_exemption_count ||= calculate_number_of_unlisted_exemptions
  end

  def partners_list
    people.map do |person|
      format_names(person.first_name, person.last_name)
    end.join(", ")
  end

  def site_description
    if site_description_abridged?
      site_address.description.truncate(max_site_description_length, separator: " ")
    else
      site_address.description
    end
  end

  def site_description_abridged?
    @_site_description_abridged ||= site_address.description.length > max_site_description_length
  end

  private

  def max_site_description_length
    200
  end

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
