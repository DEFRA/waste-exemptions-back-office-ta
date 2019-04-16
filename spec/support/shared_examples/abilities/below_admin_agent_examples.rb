# frozen_string_literal: true

RSpec.shared_examples "below admin_agent examples" do
  it "should not be able to create registrations" do
    should_not be_able_to(:create, registration)
  end

  it "should not be able to create new registrations" do
    should_not be_able_to(:create, new_registration)
  end

  it "should not be able to update new registrations" do
    should_not be_able_to(:update, new_registration)
  end
end
