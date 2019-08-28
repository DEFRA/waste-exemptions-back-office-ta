# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalLetterPresenter do
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }
end
