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
  def webpage_title
    I18n.t("confirmation_letter.single_title", reg_number: registration.reference)
  end

  def date_of_letter
    I18n.l(Time.zone.today, format: :long)
  end

  # Provides the full postal address for the letter.
  def postal_address_lines
    [
      "#{registration.contact_first_name} #{registration.contact_last_name}",
      registration.operator_name,
      address_lines(registration.contact_address)
    ].flatten!.reject(&:blank?)
  end

  def reg_details_items
    submission_date = I18n.l(registration.submitted_at.to_date, format: :long)
    filter_blank_items([
                         { key: t("reg_details_reference"), value: registration.reference },
                         { key: t("reg_details_activation_date"), value: submission_date }
                       ])
  end

  def reg_completed_by_items
    applicant_full_name = "#{registration.applicant_first_name} #{registration.applicant_last_name}"
    filter_blank_items([
                         { key: t("reg_completed_by_name"), value: applicant_full_name },
                         { key: t("reg_completed_by_telephone"), value: registration.applicant_phone },
                         { key: t("reg_completed_by_email"), value: registration.applicant_email }
                       ])
  end

  def organisation_items
    filter_blank_items([
      { key: t("organisation_type"), value: I18n.t(registration.business_type, scope: "organisation_type") },
      registration.business_type == "partnership" ? list_of_people : business_details
    ].flatten)
  end

  def waste_operation_contact_items
    contact_full_name = "#{registration.contact_first_name} #{registration.contact_last_name}"
    filter_blank_items([
                         { key: t("woc_name"), value: contact_full_name },
                         { key: t("woc_position"), value: registration.contact_position },
                         { key: t("woc_telephone"), value: registration.contact_phone },
                         { key: t("woc_email"), value: registration.contact_email }
                       ])
  end

  def site_items
    filter_blank_items([
                         { key: t("site_address"), value: address_lines(registration.site_address).join(", ") },
                         { key: t("site_ngr"), value: registration.site_address.grid_reference },
                         { key: t("site_details"), value: registration.site_address.description }
                       ])
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
        key: t(".organisation_partner_enumerator", count: index + 1),
        value: ["#{person.first_name} #{person.last_name}"]
      }
    end
  end

  def business_details
    org_name_key = "organisation_name_#{registration.business_type}"
    org_number_key = "organisation_number_#{registration.business_type}"
    org_address_key = "organisation_address_#{registration.business_type}"
    operator_address = address_lines(registration.operator_address).join(", ")
    [
      { key: t(org_name_key, default: :organisation_name_default), value: registration.operator_name },
      { key: t(org_number_key, default: :organisation_number_default), value: registration.company_no },
      { key: t(org_address_key, default: :organisation_address_default), value: operator_address }
    ]
  end
end
