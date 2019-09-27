# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Expire Registration task", type: :rake do
  include_context "rake"

  describe "expire_registration:run" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

end
