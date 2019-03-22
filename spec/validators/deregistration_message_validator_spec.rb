# frozen_string_literal: true

require "rails_helper"

module Test
  DeregistrationMessageValidatable = Struct.new(:message) do
    include ActiveModel::Validations

    validates :message, "deregistration_message": true
  end
end

module WasteExemptionsEngine
  RSpec.describe DeregistrationMessageValidator, type: :model do
    valid_message = "This exemption is no longer relevant."
    too_long_message = Helpers::TextGenerator.random_string(501) # The max length is 500.

    it_behaves_like "a validator", Test::DeregistrationMessageValidatable, :message, valid_message
    it_behaves_like "a presence validator", Test::DeregistrationMessageValidatable, :message
    it_behaves_like "a length validator", Test::DeregistrationMessageValidatable, :message, too_long_message
  end
end
