# frozen_string_literal: true

class TestMailer < ActionMailer::Base
  def test_email
    subject = "#{WasteExemptionsEngine.configuration.service_name} email"
    mail(to: Rails.configuration.email_test_address,
         subject: subject,
         from: from_address) do |format|
      format.text(content_type: "text/plain", charset: "UTF-8", content_transfer_encoding: "7bit")
    end
  end

  private

  def from_address
    from_name = WasteExemptionsEngine.configuration.service_name
    from_email = WasteExemptionsEngine.configuration.email_service_email
    "#{from_name} <#{from_email}>"
  end
end
