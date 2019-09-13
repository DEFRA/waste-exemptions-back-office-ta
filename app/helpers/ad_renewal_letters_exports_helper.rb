# frozen_string_literal: true

module AdRenewalLettersExportsHelper
  def format_email_to_name(email)
    email.scan(/(\A.*)_(.*)@/).flatten.map(&:capitalize).join(" ")
  end
end
