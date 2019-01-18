# frozen_string_literal: true

RSpec.shared_examples "admin_agent examples" do
  it "should be able to create registrations" do
    should be_able_to(:create, registration)
  end

  it "should be able to create transient registrations" do
    should be_able_to(:create, transient_registration)
  end

  it "should be able to update transient registrations" do
    should be_able_to(:update, transient_registration)
  end
end
