# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  let(:registration) { build(:registration) }
  let(:registration_exemption) { build(:registration_exemption) }
  let(:transient_registration) { build(:transient_registration) }

  context "when the user role is system" do
    let(:user) { build(:user, :system) }

    include_examples "system examples"
    include_examples "super_agent examples"
    include_examples "admin_agent examples"
    include_examples "data_agent examples"
  end

  context "when the user role is super_agent" do
    let(:user) { build(:user, :super_agent) }

    include_examples "below system examples"

    include_examples "super_agent examples"
    include_examples "admin_agent examples"
    include_examples "data_agent examples"
  end

  context "when the user role is admin_agent" do
    let(:user) { build(:user, :admin_agent) }

    include_examples "below system examples"
    include_examples "below super_agent examples"

    include_examples "admin_agent examples"
    include_examples "data_agent examples"
  end

  context "when the user role is data_agent" do
    let(:user) { build(:user, :data_agent) }

    include_examples "below system examples"
    include_examples "below super_agent examples"
    include_examples "below admin_agent examples"

    include_examples "data_agent examples"
  end
end
