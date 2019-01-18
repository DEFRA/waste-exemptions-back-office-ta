# frozen_string_literal: true

RSpec.shared_examples "below super_agent examples" do
  it "should not be able to update registrations" do
    should_not be_able_to(:update, registration)
  end

  it "should not be able to deregister registrations" do
    should_not be_able_to(:deregister, registration)
  end

  it "should not be able to deregister exemptions" do
    should_not be_able_to(:deregister, registration_exemption)
  end
end
