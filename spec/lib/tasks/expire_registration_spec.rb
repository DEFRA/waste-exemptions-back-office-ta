# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Expire Registration task" do
  include_context "rake"

  describe "expire_registration:run" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

end
