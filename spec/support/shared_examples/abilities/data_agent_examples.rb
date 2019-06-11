# frozen_string_literal: true

RSpec.shared_examples "data_agent examples" do
  it "should be able to use the back office" do
    should be_able_to(:use_back_office, :all)
  end

  it "should be able to view registrations" do
    should be_able_to(:read, registration)
  end

  it "should be able to view new registrations" do
    should be_able_to(:read, new_registration)
  end

  it "should be able to view bulk exports" do
    should be_able_to(:read, Reports::GeneratedReport)
  end
end
