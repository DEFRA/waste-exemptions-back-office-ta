# frozen_string_literal: true

RSpec.shared_examples "admin_agent examples" do
  it "should be able to create registrations" do
    should be_able_to(:create, registration)
  end

  it "should be able to create new registrations" do
    should be_able_to(:create, new_registration)
  end

  it "should be able to update new registrations" do
    should be_able_to(:update, new_registration)
  end
end
