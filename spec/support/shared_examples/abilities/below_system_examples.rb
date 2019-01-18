# frozen_string_literal: true

RSpec.shared_examples "below system examples" do
  it "should not be able to invite a user" do
    should_not be_able_to(:invite, user)
  end

  it "should not be able to view a user" do
    should_not be_able_to(:read, user)
  end

  it "should not be able to change the role of a user" do
    should_not be_able_to(:change_role, user)
  end

  it "should not be able to enable or disable a user" do
    should_not be_able_to(:enable_or_disable, user)
  end
end
