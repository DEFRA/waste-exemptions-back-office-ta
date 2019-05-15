# frozen_string_literal: true

class ConfirmationLetterPresenter
  delegate :reference, to: :registration

  def initialize(registration)
    @registration = registration
  end

  def sorted_active_registration_exemptions
    registration_exemptions_with_exemptions.where(state: :active).order(:exemption_id)
  end

  def sorted_deregistered_registration_exemptions
    registration_exemptions_with_exemptions.where("state != ?", :active).order_by_state_then_exemption_id
  end

  # Used only if the page contains a single letter.
  def web_page_title
    t("web_page_title", reg_number: registration.reference)
  end

  def date_of_letter
    Time.now.in_time_zone("London").to_date.to_formatted_s(:day_month_year)
  end

  def submission_date
    registration.submitted_at.to_date.to_formatted_s(:day_month_year)
  end

  # Provides the full postal address for the letter.
  def postal_address_lines
    [
      "#{registration.contact_first_name} #{registration.contact_last_name}",
      registration.operator_name,
      address_lines(registration.contact_address)
    ].flatten!.reject(&:blank?)
  end

  def registration_completed_by_items
    applicant_full_name = "#{registration.applicant_first_name} #{registration.applicant_last_name}"
    filter_blank_items([
                         { key: t("registration_completed_by.name"), value: applicant_full_name },
                         { key: t("registration_completed_by.telephone"), value: registration.applicant_phone },
                         { key: t("registration_completed_by.email"), value: registration.applicant_email }
                       ])
  end

  def business_details_items
    filter_blank_items([
      { key: t("business_details.type"), value: I18n.t(registration.business_type, scope: "organisation_type") },
      registration.business_type == "partnership" ? list_of_people : business_details
    ].flatten)
  end

  def waste_operation_contact_items
    contact_full_name = "#{registration.contact_first_name} #{registration.contact_last_name}"
    filter_blank_items([
                         { key: t("waste_operation_contact.name"), value: contact_full_name },
                         { key: t("waste_operation_contact.position"), value: registration.contact_position },
                         { key: t("waste_operation_contact.telephone"), value: registration.contact_phone },
                         { key: t("waste_operation_contact.email"), value: registration.contact_email }
                       ])
  end

  def waste_operation_location_items
    filter_blank_items([
                         { key: t("waste_operation_location.address"), value: address_lines(registration.site_address).join(", ") },
                         { key: t("waste_operation_location.ngr"), value: registration.site_address.grid_reference },
                         { key: t("waste_operation_location.details"), value: registration.site_address.description }
                       ])
  end

  def exemption_description(exemption)
    "#{exemption.code}: #{exemption.summary}"
  end

  def registration_exemption_status(registration_exemption)
    display_date = if registration_exemption.state == "active"
                     registration_exemption.expires_on.to_formatted_s(:day_month_year)
                   else
                     registration_exemption.deregistered_on.to_formatted_s(:day_month_year)
                   end

    t(
      "waste_exemptions.status.#{registration_exemption.state}",
      display_date: display_date
    )
  end

  private

  attr_reader :registration

  def registration_exemptions_with_exemptions
    registration.registration_exemptions.includes(:exemption)
  end

  def t(key, options = {})
    I18n.t(key, { scope: "confirmation_letter.show" }.merge!(options))
  end

  def filter_blank_items(items)
    items.reject { |item| item[:value].blank? }
  end

  def address_lines(address)
    return [] unless address

    address_fields = %i[organisation premises street_address locality city postcode]
    address_fields.map { |field| address.public_send(field) }.reject(&:blank?)
  end

  def list_of_people
    registration.people.each_with_index.map do |person, index|
      {
        key: t(".business_details.partner_enumerator", count: index + 1),
        value: ["#{person.first_name} #{person.last_name}"]
      }
    end
  end

  def business_details
    org_type = registration.business_type.underscore
    org_type = "default" unless %w[limited_company limited_liability_partnership].include? org_type
    org_name_key = "business_details.name_#{org_type}"
    org_number_key = "business_details.number_#{org_type}"
    org_address_key = "business_details.address_#{org_type}"
    operator_address = address_lines(registration.operator_address).join(", ")
    [
      { key: t(org_name_key), value: registration.operator_name },
      { key: t(org_number_key), value: registration.company_no },
      { key: t(org_address_key), value: operator_address }
    ]
  end
end
