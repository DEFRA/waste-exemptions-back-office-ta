# frozen_string_literal: true

class BaseLetterPresenter < BasePresenter
  def contact_full_name
    format_name(contact_first_name, contact_last_name)
  end

  # Provides the full postal address for the letter.
  def postal_address_lines
    [
      contact_full_name,
      operator_name,
      address_lines(contact_address)
    ].flatten!.reject(&:blank?)
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
