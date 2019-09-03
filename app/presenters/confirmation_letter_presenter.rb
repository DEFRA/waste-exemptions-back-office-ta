# frozen_string_literal: true

class ConfirmationLetterPresenter < BaseLetterPresenter

  def sorted_active_registration_exemptions
    registration_exemptions_with_exemptions.where(state: :active).order(:exemption_id)
  end

  def sorted_deregistered_registration_exemptions
    registration_exemptions_with_exemptions.where("state != ?", :active).order_by_state_then_exemption_id
  end

  def submission_date
    submitted_at.to_date.to_formatted_s(:day_month_year)
  end

  def applicant_full_name
    format_names(applicant_first_name, applicant_last_name)
  end

  # Provides the full postal address for the letter.
  def postal_address_lines
    [
      contact_full_name,
      operator_name,
      address_lines(contact_address)
    ].flatten!.reject(&:blank?)
  end

  def partners
    people.each_with_index.map do |person, index|
      {
        label: I18n.t("business_details.partner_enumerator", scope: "confirmation_letter.show", count: index + 1),
        name: format_names(person.first_name, person.last_name)
      }
    end
  end

  def exemption_description(exemption)
    "#{exemption.code}: #{exemption.summary}"
  end

  def registration_exemption_status(registration_exemption)
    display_date = if registration_exemption.active? || registration_exemption.expired?
                     registration_exemption.expires_on.to_formatted_s(:day_month_year)
                   else
                     registration_exemption.deregistered_at.to_formatted_s(:day_month_year)
                   end

    I18n.t(
      "waste_exemptions.status.#{registration_exemption.state}",
      scope: "confirmation_letter.show",
      display_date: display_date
    )
  end

  private

  def registration_exemptions_with_exemptions
    registration_exemptions.includes(:exemption)
  end
end
