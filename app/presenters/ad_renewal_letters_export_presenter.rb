# frozen_string_literal: true

class AdRenewalLettersExportPresenter < BasePresenter
  def downloadable?
    succeded? && number_of_letters.positive?
  end

  def expire_date
    @_expire_date ||= expires_on.to_formatted_s(:abbr_week_day_month)
  end

  def letters_label
    if number_of_letters.positive?
      I18n.t("ad_renewal_letters_exports.index.table.letters_label", number_of_letters: number_of_letters)
    else
      I18n.t("ad_renewal_letters_exports.index.labels.no_renewals")
    end
  end

  def print_label
    return if failed?

    return printed_label if printed?
    return none_to_print_label if number_of_letters.zero?
  end

  private

  def printed_label
    I18n.t(
      "ad_renewal_letters_exports.index.labels.printed",
      printed_by: printed_by_label,
      printed_on: printed_on.to_formatted_s(:abbr_week_day_month)
    )
  end

  def printed_by_label
    printed_by.scan(/(\A.*)\.(.*)@/).flatten.map(&:capitalize).join(" ")
  end

  def none_to_print_label
    I18n.t("ad_renewal_letters_exports.index.labels.none_to_print")
  end
end
