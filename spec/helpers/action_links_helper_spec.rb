# frozen_string_literal: true

require "rails_helper"

# Add #can? to the module so it can be stubbed in the tests
module ActionLinksHelper
  def can?(_action, _resource)
    false
  end
end

RSpec.describe ActionLinksHelper, type: :helper do
  include Devise::Test::ControllerHelpers

  describe "view_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq(registration_path(resource.reference))
      end
    end

    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq(new_registration_path(resource.id))
      end
    end

    context "when the resource is not a registration or a new_registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq("#")
      end
    end
  end

  describe "resume_link_for" do
    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      it "returns the correct path" do
        path = WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path(resource.token)
        expect(helper.resume_link_for(resource)).to eq(path)
      end
    end

    context "when the resource is not a new_registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq("#")
      end
    end
  end

  describe "edit_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        path = WasteExemptionsEngine::Engine.routes.url_helpers.new_edit_form_path(resource.reference)
        expect(helper.edit_link_for(resource)).to eq(path)
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.edit_link_for(resource)).to eq("#")
      end
    end
  end

  describe "display_resume_link_for?" do
    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        it "returns true" do
          expect(helper.display_resume_link_for?(resource)).to eq(true)
        end
      end

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to eq(false)
        end
      end
    end

    context "when the resource is not a new_registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_resume_link_for?(resource)).to eq(false)
      end
    end
  end

  describe "display_edit_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the user has permission to update a registration" do
        before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:update, resource).and_return(true) }

        it "returns true" do
          expect(helper.display_edit_link_for?(resource)).to eq(true)
        end
      end

      context "when the user does not have permission to update a registration" do
        before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:update, resource).and_return(false) }

        it "returns false" do
          expect(helper.display_edit_link_for?(resource)).to eq(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_edit_link_for?(resource)).to eq(false)
      end
    end
  end

  describe "display_deregister_link_for?" do
    context "when the resource is an active registration" do
      let(:resource) do
        registration = create(:registration)
        registration.registration_exemptions.each do |re|
          re.state = "active"
          re.save!
        end
        registration
      end

      context "when the user has permission to deregister a registration" do
        before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:deregister, resource).and_return(true) }

        it "returns true" do
          expect(helper.display_deregister_link_for?(resource)).to eq(true)
        end
      end

      context "when the user does not have permission to deregister a registration" do
        before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:deregister, resource).and_return(false) }

        it "returns false" do
          expect(helper.display_deregister_link_for?(resource)).to eq(false)
        end
      end
    end

    context "when the resource is an inactive registration" do
      let(:resource) do
        registration = create(:registration)
        registration.registration_exemptions.each(&:revoke!)
        registration
      end

      it "returns false" do
        expect(helper.display_deregister_link_for?(resource)).to eq(false)
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_deregister_link_for?(resource)).to eq(false)
      end
    end
  end

  describe "display_confirmation_letter_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns true" do
        expect(helper.display_confirmation_letter_link_for?(resource)).to eq(true)
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_confirmation_letter_link_for?(resource)).to eq(false)
      end
    end
  end

  describe "display_renew_links_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the resource is in the renewal window" do
        before(:each) { allow(resource).to receive(:in_renewal_window?).and_return(true) }

        context "when the user has permission to renew" do
          before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:renew, resource).and_return(true) }

          context "when the resource has active exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "active"
                re.save!
              end
            end

            it "returns true" do
              expect(helper.display_renew_links_for?(resource)).to eq(true)
            end
          end

          context "when the resource has expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "expired"
                re.save!
              end
            end

            it "returns true" do
              expect(helper.display_renew_links_for?(resource)).to eq(true)
            end
          end

          context "when the resource has no active or expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "ceased"
                re.save!
              end
            end

            it "returns false" do
              expect(helper.display_renew_links_for?(resource)).to eq(false)
            end
          end
        end

        context "when the user does not have permission to renew" do
          before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:renew, resource).and_return(false) }

          it "returns false" do
            expect(helper.display_renew_links_for?(resource)).to eq(false)
          end
        end
      end

      context "when the resource is not in the renewal window" do
        before(:each) { allow(resource).to receive(:in_renewal_window?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_links_for?(resource)).to eq(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_renew_links_for?(resource)).to eq(false)
      end
    end
  end

  describe "display_renew_window_closed_text_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the resource is past the renewal window" do
        before(:each) { allow(resource).to receive(:past_renewal_window?).and_return(true) }

        context "when the user has permission to renew" do
          before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:renew, resource).and_return(true) }

          context "when the resource has active exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "active"
                re.save!
              end
            end

            it "returns true" do
              expect(helper.display_renew_window_closed_text_for?(resource)).to eq(true)
            end
          end

          context "when the resource has expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "expired"
                re.save!
              end
            end

            it "returns true" do
              expect(helper.display_renew_window_closed_text_for?(resource)).to eq(true)
            end
          end

          context "when the resource has no active or expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "ceased"
                re.save!
              end
            end

            it "returns false" do
              expect(helper.display_renew_window_closed_text_for?(resource)).to eq(false)
            end
          end
        end

        context "when the user does not have permission to renew" do
          before(:each) { allow_any_instance_of(described_class).to receive(:can?).with(:renew, resource).and_return(false) }

          it "returns false" do
            expect(helper.display_renew_window_closed_text_for?(resource)).to eq(false)
          end
        end
      end

      context "when the resource is not in the renewal window" do
        before(:each) { allow(resource).to receive(:in_renewal_window?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_window_closed_text_for?(resource)).to eq(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_renew_window_closed_text_for?(resource)).to eq(false)
      end
    end
  end
end
