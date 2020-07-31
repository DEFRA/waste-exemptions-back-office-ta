# frozen_string_literal: true

RSpec.shared_examples "developer examples" do
  it "should be able to toggle features" do
    should be_able_to(:manage, WasteExemptionsEngine::FeatureToggle)
  end
end
