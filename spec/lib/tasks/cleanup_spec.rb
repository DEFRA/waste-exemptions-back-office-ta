# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cleanup task" do
  include_context "rake"

  describe "cleanup:transient_registrations" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

end
