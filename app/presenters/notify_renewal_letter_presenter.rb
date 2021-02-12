# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class NotifyRenewalLetterPresenter < BasePresenter
  MAX_SITE_DESCRIPTION_LENGTH = 200

  def expiry_date
    # Currently you can only add exemptions when you register, so we can assume they expire at the same time
    registration_exemptions.first.expires_on.to_formatted_s(:day_month_year)
  end

  def contact_name
    "#{contact_first_name} #{contact_last_name}"
  end

  def exemptions_text
    items = []

    listable_exemptions.each do |exemption|
      items << exemption_description(exemption)
    end

    items << unlisted_exemptions_text if unlisted_exemption_count.positive?

    items
  end

  def business_details_section
    items = []

    items << business_type_text

    if partnership?
      items << partners_text
    else
      items << business_name_text
      items << company_no_text if company_no.present?
    end

    items.concat(location_section)

    items
  end

  private

  # Exemptions

  def exemption_description(exemption)
    "#{exemption.code} #{exemption.summary}"
  end

  def unlisted_exemptions_text
    I18n.t("renewal_letter.renewal_letter_content.section_4.more_exemptions", count: unlisted_exemption_count)
  end

  def relevant_exemptions
    @_relevant_exemptions ||= expired_and_active_exemptions.order(:id)
  end

  def listable_exemptions
    @_listable_exemptions ||= relevant_exemptions.first(18)
    @_listable_exemptions
  end

  def unlisted_exemption_count
    @_unlisted_exemption_count ||= calculate_number_of_unlisted_exemptions
  end

  def calculate_number_of_unlisted_exemptions
    total_exemption_count = relevant_exemptions.count
    listable_exemptions_count = listable_exemptions.count

    if listable_exemptions_count < total_exemption_count
      total_exemption_count - listable_exemptions_count
    else
      0
    end
  end

  # Business details

  def business_type_text
    human_business_type = I18n.t("waste_exemptions_engine.pdfs.certificate.busness_types.#{business_type}")
    label_and_value("business_type_label", human_business_type)
  end

  def partners_text
    partners_list = []

    people.each do |partner|
      partners_list << "#{partner.first_name} #{partner.last_name}"
    end

    label_and_value("partners_label", partners_list.join(", "))
  end

  def business_name_text
    label_and_value("operator_label.#{business_type}", operator_name)
  end

  def company_no_text
    label_and_value("company_no_label.#{business_type}", company_no)
  end

  # Location

  def location_section
    items = []

    if site_address.located_by_grid_reference?
      items << grid_reference_text
      items << site_description_text
      items << site_description_abridged_text if site_description_abridged?
    else
      items << site_address_text
    end

    items
  end

  def site_address_text
    address = address_lines(site_address).join(", ")
    label_and_value("site_label", address)
  end

  def grid_reference_text
    label_and_value("site_label", site_address.grid_reference)
  end

  def site_description_text
    if site_description_abridged?
      site_address.description.truncate(MAX_SITE_DESCRIPTION_LENGTH, separator: " ")
    else
      site_address.description
    end
  end

  def site_description_abridged_text
    I18n.t("renewal_letter.renewal_letter_content.section_4.more_site_description")
  end

  def site_description_abridged?
    @_site_description_abridged ||= site_address.description.length > MAX_SITE_DESCRIPTION_LENGTH
  end

  # Utility methods

  def label_and_value(label, value)
    label_text = I18n.t("renewal_letter.renewal_letter_content.section_4.#{label}")
    "#{label_text} #{value}"
  end

  def address_lines(address)
    return [] unless address

    address_fields = %i[organisation premises street_address locality city postcode]
    address_fields.map { |field| address.public_send(field) }.reject(&:blank?)
  end
end
# rubocop:enable Metrics/ClassLength
