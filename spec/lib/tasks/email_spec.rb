# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Email task", type: :rake do
  include_context "rake"

  # We have this test declared here as a way of recording a decision. The
  # test requires that the env var EMAIL_TEST_ADDRESS is specified, which
  # is no big problem but is a slight hindrance. Mainly it's because when run
  # it just spits out text to the console. This messes up our rspec output
  # format, and we don't like that!
  #
  # If this was a more important function we'd properly cover it, but in this
  # case we are happy to skip the test coverage.
  describe "email:test", skip: "We don't want to cover this!" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:anonymise" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:renew_reminder:first:send" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:renew_reminder:second:send" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

end
