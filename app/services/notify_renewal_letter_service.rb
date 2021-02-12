# frozen_string_literal: true

require "notifications/client"

class NotifyRenewalLetterService < ::WasteExemptionsEngine::BaseService
  # So we can use displayable_address()
  include ::WasteExemptionsEngine::ApplicationHelper

  def run(registration:)
    @registration = NotifyRenewalLetterPresenter.new(registration)

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    client.send_letter(template_id: template,
                       personalisation: personalisation)
  end

  private

  def template
    "8251a044-bdbe-4568-a82a-7b499dfe3775"
  end

  def personalisation
    {
      expiry_date: @registration.expiry_date,
      contact_name: @registration.contact_name,
      reference: @registration.reference,
      exemptions: @registration.exemptions_text,
      business_details: @registration.business_details_section
    }.merge(address_lines)
  end

  def address_lines
    address_values = [
      @registration.contact_name,
      displayable_address(@registration.contact_address)
    ].flatten

    address_hash = {}

    address_values.each_with_index do |value, index|
      line_number = index + 1
      address_hash["address_line_#{line_number}"] = value
    end

    address_hash
  end
end
