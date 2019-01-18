# frozen_string_literal: true

RSpec.shared_examples "super_agent examples" do
  it "should be able to update registrations" do
    should be_able_to(:update, registration)
  end

  it "should be able to deregister registrations" do
    should be_able_to(:deregister, registration)
  end

  it "should be able to deregister exemptions" do
    should be_able_to(:deregister, registration_exemption)
  end
end
