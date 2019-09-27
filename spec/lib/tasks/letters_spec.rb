# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Letters task" do
  include_context "rake"

  describe "letters:export:ad_renewals" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

end
