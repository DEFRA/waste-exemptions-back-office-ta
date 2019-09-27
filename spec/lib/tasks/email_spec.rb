# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Email task" do
  include_context "rake"

  describe "email:test" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:anonymise" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:renew_reminder:first:send" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:renew_reminder:second:send" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

end
