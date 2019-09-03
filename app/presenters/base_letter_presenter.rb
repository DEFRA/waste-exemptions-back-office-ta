# frozen_string_literal: true

class BaseLetterPresenter < BasePresenter
  include WasteExemptionsEngine::ApplicationHelper

  def contact_full_name
    format_names(contact_first_name, contact_last_name)
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

  def site_address_one_liner
    address_lines(site_address).join(", ")
  end

  private

  def address_lines(address)
    return [] unless address

    address_fields = %i[organisation premises street_address locality city postcode]
    address_fields.map { |field| address.public_send(field) }.reject(&:blank?)
  end
end
