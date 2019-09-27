# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reminder task" do
  include_context "rake"

  before(:all) { create(:registration, :with_active_exemptions) }

  describe "reminder:first" do
    let(:task_name) { self.class.description }

    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reminder:second" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

end
