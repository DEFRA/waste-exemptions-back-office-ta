# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#role" do
    context "when the role is in the allowed list" do
      let(:user) { build(:user, role: "system") }

      it "should be valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is not in the allowed list" do
      let(:user) { build(:user, role: "foo") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end
  end

  describe "#password" do
    context "when the user's password meets the requirements" do
      let(:user) { build(:user, password: "Secret123") }

      it "should be valid" do
        expect(user).to be_valid
      end
    end

    context "when the user's password is blank" do
      let(:user) { build(:user, password: "") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password has no lowercase letters" do
      let(:user) { build(:user, password: "SECRET123") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password has no uppercase letters" do
      let(:user) { build(:user, password: "secret123") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password has no numbers" do
      let(:user) { build(:user, password: "SuperSecret") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password is too short" do
      let(:user) { build(:user, password: "Sec123") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end
  end

  describe "active?" do
    let(:user) { build(:user) }

    context "when active is true" do
      it "returns true" do
        expect(user.active?).to eq(true)
      end
    end

    context "when active is false" do
      before { user.active = false }

      it "returns false" do
        expect(user.active?).to eq(false)
      end
    end
  end

  describe "activate" do
    let(:user) { build(:user, :inactive) }

    it "makes the user active" do
      user.activate!
      expect(user.active?).to eq(true)
    end
  end

  describe "deactivate" do
    let(:user) { build(:user) }

    it "makes the user inactive" do
      user.deactivate!
      expect(user.active?).to eq(false)
    end
  end

  describe "role_is?" do
    let(:user) { build(:user, role: "system") }

    context "when the user has the same role" do
      it "should return true" do
        role = user.role
        expect(user.role_is?(role)).to eq(true)
      end
    end

    context "when the user has a different role" do
      it "should return false" do
        role = "data_agent"
        expect(user.role_is?(role)).to eq(false)
      end
    end
  end

  describe "change_role" do
    let(:user) { build(:user, :data_agent) }

    it "should update the user's role" do
      new_role = "admin_agent"
      user.change_role!(new_role)

      expect(user.role).to eq(new_role)
    end

    context "when the new role is invalid" do
      it "should raise an error" do
        expect { user.change_role!("foo") }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
