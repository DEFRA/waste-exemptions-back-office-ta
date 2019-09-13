# frozen_string_literal: true

module AdRenewalLettersExportsHelper
  def format_email_to_name(email)
    email.scan(/(\A.*)\.(.*)@/).flatten.map(&:capitalize).join(" ")
  end
end
