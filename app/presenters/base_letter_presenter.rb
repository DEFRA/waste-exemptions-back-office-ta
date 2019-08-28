# frozen_string_literal: true

class BaseLetterPresenter < BasePresenter
  def contact_full_name
    format_name(contact_first_name, contact_last_name)
  end

  def date_of_letter
    Time.now.to_date.to_formatted_s(:day_month_year)
  end

  def human_business_type
    I18n.t("waste_exemptions_engine.pdfs.certificate.busness_types.#{business_type}")
  end

  def operator_address_one_liner
    address_lines(operator_address).join(", ")
  end

  # Provides the full postal address for the letter.
  def postal_address_lines
    [
      contact_full_name,
      operator_name,
      address_lines(contact_address)
    ].flatten!.reject(&:blank?)
  end

  def site_address_one_liner
    address_lines(site_address).join(", ")
  end

  private

  def format_name(first_name, last_name)
    "#{first_name} #{last_name}"
  end

  def address_lines(address)
    return [] unless address

    address_fields = %i[organisation premises street_address locality city postcode]
    address_fields.map { |field| address.public_send(field) }.reject(&:blank?)
  end
end
