# frozen_string_literal: true

require "notifications/client"

class FirstRenewalReminderEmailService < RenewalReminderEmailService
  private

  def template
    "1ef273a9-b5e5-4a48-a343-cf6c774b8211"
  end
end
