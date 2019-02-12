# frozen_string_literal: true

RSpec.shared_examples "system examples" do
  it "should be able to invite a user" do
    should be_able_to(:invite, user)
  end

  it "should be able to view a user" do
    should be_able_to(:read, user)
  end

  it "should be able to change the role of a user" do
    should be_able_to(:change_role, user)
  end

  it "should be able to activate or deactivate a user" do
    should be_able_to(:activate_or_deactivate, user)
  end
end
